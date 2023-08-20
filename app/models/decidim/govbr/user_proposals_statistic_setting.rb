# frozen_string_literal: true

module Decidim
  module Govbr
    # TODO: comment doc for the entire class
    class UserProposalsStatisticSetting < ApplicationRecord
      self.table_name = 'decidim_govbr_user_proposals_statistic_settings'

      has_many :user_proposals_statistics, class_name: 'Decidim::Govbr::UserProposalsStatistic'

      # Rebuild entire table from scratch with updated decidim database content for the specified participatory_space
      def refresh_data
        user_proposals_statistics.delete_all

        refresh_user_proposals_data
        refresh_user_comments_data
        refresh_user_votes_data
        refresh_user_follows_data
      end

      def refresh_user_proposals_data
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