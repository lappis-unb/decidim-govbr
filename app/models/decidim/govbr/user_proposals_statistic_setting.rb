# frozen_string_literal: true

module Decidim
  module Govbr
    # TODO: comment doc for the entire class
    class UserProposalsStatisticSetting < ApplicationRecord
      self.table_name = 'decidim_govbr_user_proposals_statistic_settings'

      include Decidim::Traceable
      include Decidim::Loggable

      STATISTIC_FIELDS = %w(proposals_done votes_received comments_received follows_received comments_done votes_done follows_done).freeze

      belongs_to :decidim_participatory_space, polymorphic: true
      has_many :user_proposals_statistics, class_name: 'Decidim::Govbr::UserProposalsStatistic', dependent: :destroy

      delegate :organization, to: :decidim_participatory_space

      # Return the identifier for last calculated statistics
      #
      def last_generated_statistics_data_identifier
        "#{name.delete(",;").parameterize}-#{statistics_data_updated_at}"
      end

      def user_proposals_statistics_as_csv
        attributes = Decidim::Govbr::UserProposalsStatistic.csv_attributes_header_map

        CSV.generate(headers: true) do |csv|
          csv << attributes.values
          user_proposals_statistics.order(score: :desc).each do |data|
            csv << attributes.keys.map{ |attr| data.send(attr) }
          end
        end
      end

      # Rebuild entire table from scratch with updated decidim database content for the specified participatory_space
      # This is a heavy weight method!!!
      #
      def refresh_data!
        user_proposals_statistics.delete_all
        generate_and_persist_updated_statistics_data
      end

      # Fire database queries to fetch statistic data and return them in an array, where each position represents
      # a unique user related statistics data
      #
      def statistics_data
        return @statistics_data if @statistics_data

        @statistics_data = Hash.new { |hash, key| hash[key] = {} }
        [get_user_proposals_data, get_user_comments_data, get_user_votes_data, get_user_follows_data].each do |data|
          data.each { |user_data| @statistics_data[user_data['decidim_user_id']].merge!(user_data) }
        end

        @statistics_data = @statistics_data.values
      end

      # Generate statistics data and then post process it by filling absent fields and calculating the user score
      #
      def generate_and_process_statistics_data
        statistics_data.each do |data|
          data["score"] = 0.0

          STATISTIC_FIELDS.each do |field|
            data[field] = data[field].presence || 0.0
            data["score"] += data[field] * send("#{field}_weight").to_f
          end

          data["created_at"] = Time.current
          data["updated_at"] = Time.current
          data["user_proposals_statistic_setting_id"] = id
        end
      end

      def generate_and_persist_updated_statistics_data
        generate_and_process_statistics_data
        Decidim::Govbr::UserProposalsStatistic.insert_all(statistics_data) if statistics_data.present?
        update_column(:statistics_data_updated_at, Time.zone.now)
      end

      def get_user_proposals_data
        ActiveRecord::Base.connection.execute(
          <<~SQL.squish
          SELECT du.id as decidim_user_id, du.name as decidim_user_name, COUNT(dpp.id) as proposals_done, SUM(dpp.proposal_votes_count) as votes_received, SUM(dpp.comments_count) as comments_received, SUM(dpp.follows_count) as follows_received
            FROM decidim_components as dc
            INNER JOIN decidim_proposals_proposals as dpp
              ON dc.id = dpp.decidim_component_id
            INNER JOIN decidim_coauthorships as coauth
              ON coauth.coauthorable_type = 'Decidim::Proposals::Proposal' AND coauth.coauthorable_id = dpp.id
            INNER JOIN decidim_users as du
              ON du.id = coauth.decidim_author_id
            WHERE dc.participatory_space_type = '#{decidim_participatory_space_type}'
              AND dc.participatory_space_id = '#{decidim_participatory_space_id}'
          GROUP BY du.id
          SQL
        )
      end

      def get_user_comments_data
        ActiveRecord::Base.connection.execute(
          <<~SQL.squish
          SELECT du.id as decidim_user_id, du.name as decidim_user_name, COUNT(dcc.id) as comments_done
            FROM decidim_components as dc
            INNER JOIN decidim_proposals_proposals as dpp
              ON dc.id = dpp.decidim_component_id
            INNER JOIN decidim_comments_comments as dcc
              ON dcc.decidim_commentable_id = dpp.id
            INNER JOIN decidim_users as du
              ON du.id = dcc.decidim_author_id
            WHERE dcc.decidim_commentable_type = 'Decidim::Proposals::Proposal'
              AND dc.participatory_space_type = '#{decidim_participatory_space_type}'
              AND dc.participatory_space_id = '#{decidim_participatory_space_id}'
          GROUP BY du.id
          SQL
        )
      end

      def get_user_votes_data
        ActiveRecord::Base.connection.execute(
          <<~SQL.squish
          SELECT du.id as decidim_user_id, du.name as decidim_user_name, COUNT(dppv.id) as votes_done
            FROM decidim_components as dc
            INNER JOIN decidim_proposals_proposals as dpp
              ON dc.id = dpp.decidim_component_id
            INNER JOIN decidim_proposals_proposal_votes as dppv
              ON dppv.decidim_proposal_id = dpp.id
            INNER JOIN decidim_users as du
              ON du.id = dppv.decidim_author_id
            WHERE dc.participatory_space_type = '#{decidim_participatory_space_type}'
              AND dc.participatory_space_id = '#{decidim_participatory_space_id}'
          GROUP BY du.id
          SQL
        )
      end

      def get_user_follows_data
        ActiveRecord::Base.connection.execute(
          <<~SQL.squish
          SELECT du.id as decidim_user_id, du.name as decidim_user_name, COUNT(df.id) as follows_done
            FROM decidim_components as dc
            INNER JOIN decidim_proposals_proposals as dpp
              ON dc.id = dpp.decidim_component_id
            INNER JOIN decidim_follows as df
              ON df.decidim_followable_id = dpp.id
            INNER JOIN decidim_users as du
              ON du.id = df.decidim_user_id
            WHERE df.decidim_followable_type = 'Decidim::Proposals::Proposal'
              AND dc.participatory_space_type = '#{decidim_participatory_space_type}'
              AND dc.participatory_space_id = '#{decidim_participatory_space_id}'
          GROUP BY du.id
          SQL
        )
      end

      def self.log_presenter_class_for(_log)
        Decidim::Govbr::AdminLog::UserProposalsStatisticSettingPresenter
      end

      alias participatory_space decidim_participatory_space
      alias participatory_space= decidim_participatory_space=
    end
  end
end