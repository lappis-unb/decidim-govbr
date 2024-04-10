# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # A form object used to create user proposals statistic settings.
      class UserProposalsStatisticSettingForm < Form
        mimic :participatory_space_user_proposals_statistic_setting

        attribute :name, String
        attribute :proposals_done_weight, Float, default: 1.0
        attribute :comments_done_weight, Float, default: 1.0
        attribute :votes_done_weight, Float, default: 1.0
        attribute :follows_done_weight, Float, default: 1.0
        attribute :votes_received_weight, Float, default: 1.0
        attribute :comments_received_weight, Float, default: 1.0
        attribute :follows_received_weight, Float, default: 1.0
        attribute :users_to_be_exported, Integer, default: 200

        validates :name,
                  :proposals_done_weight,
                  :comments_done_weight,
                  :votes_done_weight,
                  :follows_done_weight,
                  :votes_received_weight,
                  :comments_received_weight,
                  :follows_received_weight,
                  :users_to_be_exported,
                  presence: true

        alias organization current_organization
      end
    end
  end
end
