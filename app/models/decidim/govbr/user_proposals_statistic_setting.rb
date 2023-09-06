# frozen_string_literal: true

module Decidim
  module Govbr
    # TODO: comment doc for the entire class
    class UserProposalsStatisticSetting < ApplicationRecord
      self.table_name = 'decidim_govbr_user_proposals_statistic_settings'

      has_many :user_proposals_statistics, class_name: 'Decidim::Govbr::UserProposalsStatistic'

      def user_proposals_statistics_as_csv
        attributes = Decidim::Govbr::UserProposalsStatistic.csv_attributes_header_map.to_h

        CSV.generate(headers: true) do |csv|
          csv << attributes.values

          user_proposals_statistics.each do |data|
            csv << attributes.keys.map{ |attr| data.send(attr) }
          end
        end
      end

      # Rebuild entire table from scratch with updated decidim database content for the specified participatory_space
      def refresh_data!
        user_proposals_statistics.delete_all

        statistic_data = {}

        compilied_data = [
          get_user_proposals_data,
          get_user_comments_data,
          get_user_votes_data,
          get_user_follows_data
        ]

        compilied_data.each do |data|
          data.to_a.each { |user_data|
            statistic_data[user_data['decidim_user_id']] = (statistic_data[user_data['decidim_user_id']] || {}).merge(user_data)
          }
        end

        user_identification_numbers = get_user_identification_numbers(statistic_data.keys)

        statistic_data.each do |user_id, data|
          data['user_proposals_statistic_setting_id'] = id

          proposals_done        = data['proposals_done'].to_f * self.proposals_done_weight
          comments_done_weight  = data['comments_done'].to_f * self.comments_done_weight
          votes_done            = data['votes_done'].to_f * self.votes_done_weight
          follows_done          = data['follows_done'].to_f * self.follows_done_weight
          votes_received        = data['votes_received'].to_f * self.votes_received_weight
          comments_received     = data['comments_received'].to_f * self.comments_received_weight
          follows_received      = data['follows_received'].to_f * self.follows_received_weight


          data['score'] = (proposals_done + votes_done + comments_received + follows_received + comments_done_weight + follows_done + votes_received)
          data['created_at'] = Time.current
          data['updated_at'] = Time.current
          data['decidim_user_identification_number'] = user_identification_numbers[user_id].presence || 'CPF vazio'
        end

        Decidim::Govbr::UserProposalsStatistic.insert_all(statistic_data.values)

        self.touch
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
          SELECT du.id as decidim_user_id, COUNT(dcc.id) as comments_done
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
          SELECT du.id as decidim_user_id, COUNT(dppv.id) as votes_done
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
          SELECT du.id as decidim_user_id, COUNT(df.id) as follows_done
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

      def get_user_identification_numbers(user_ids)
        Decidim::Identity.where(decidim_user_id: user_ids).map { |identity| [identity.decidim_user_id, identity.uid] }.to_h
      end
    end
  end
end