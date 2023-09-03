# frozen_string_literal: true

module Decidim
  module Govbr
    # TODO: comment doc for the entire class
    class UserProposalsStatisticSetting < ApplicationRecord
      self.table_name = 'decidim_govbr_user_proposals_statistic_settings'

      has_many :user_proposals_statistics, class_name: 'Decidim::Govbr::UserProposalsStatistic'

      def proposals
        @proposals ||= Decidim::Proposals::Proposal.where(
          component: Decidim::Component.where(
            participatory_space_id: decidim_participatory_space_id,
            participatory_space_type: decidim_participatory_space_type
          )
        )
      end

      def users
        @users ||= Decidim::User.joins(:coauthorships).
          where(coauthorships: {
              coauthorable: proposals
            }
          )
      end

      # Rebuild entire table from scratch with updated decidim database content for
      # the specified participatory_space
      def refresh_data
        user_proposals_statistics.delete_all

        refresh_user_proposals_authorship_data
        refresh_user_comments_data
        refresh_user_votes_data
        refresh_user_follows_data
      end

      def refresh_user_proposals_authorship_data
        Decidim::User.find_each do |u|
          user_proposals_statistics.create(decidim_user_id: u.id)
        end
      end

      def refresh_user_comments_data

      end

      def refresh_user_votes_data

      end

      def refresh_user_follows_data

      end
    end
  end
end