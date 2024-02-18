# frozen_string_literal: true

module Decidim
  module Govbr
    module AdminLog
      # This class holds the logic to present a `Decidim::Govbr::UserProposalsStatisticSetting`
      # for the `AdminLog` log.
      #
      # Usage should be automatic and you shouldn't need to call this class
      # directly, but here's an example:
      #
      #    action_log = Decidim::ActionLog.last
      #    view_helpers # => this comes from the views
      class UserProposalsStatisticSettingPresenter < Decidim::Log::BasePresenter
        private

        def diff_fields_mapping
          {
            name: :string,
            proposals_done_weight: :float,
            comments_done_weight: :float,
            votes_done_weight: :float,
            follows_done_weight: :float,
            votes_received_weight: :float,
            comments_received_weight: :float,
            follows_received_weight: :float,
            users_to_be_exported: :integer
          }
        end

        def i18n_labels_scope
          "activemodel.attributes.participatory_space_user_proposals_statistic_setting"
        end

        def action_string
          case action
          when "create", "delete", "update"
            "decidim.admin_log.govbr.user_proposals_statistic_setting.#{action}"
          else
            super
          end
        end

        def diff_actions
          super + %w(delete)
        end
      end
    end
  end
end
