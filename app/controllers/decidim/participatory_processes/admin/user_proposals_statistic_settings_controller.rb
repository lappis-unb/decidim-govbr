# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # Controller that allows managing participatory process media links.
      class UserProposalsStatisticSettingsController < Decidim::Govbr::Admin::UserProposalsStatisticSettingsController
        include Concerns::ParticipatoryProcessAdmin

        helper_method :new_participatory_space_user_proposals_statistic_setting_path,
                      :edit_participatory_space_user_proposals_statistic_setting_path,
                      :participatory_space_user_proposals_statistic_setting_path,
                      :participatory_space_user_proposals_statistic_settings_path,
                      :export_participatory_space_user_proposals_statistic_setting_path

        # rubocop:disable Layout/ExtraSpacing
        alias new_participatory_space_user_proposals_statistic_setting_path     new_participatory_process_user_proposals_statistic_setting_path
        alias edit_participatory_space_user_proposals_statistic_setting_path    edit_participatory_process_user_proposals_statistic_setting_path
        alias participatory_space_user_proposals_statistic_setting_path         participatory_process_user_proposals_statistic_setting_path
        alias participatory_space_user_proposals_statistic_settings_path        participatory_process_user_proposals_statistic_settings_path
        alias export_participatory_space_user_proposals_statistic_setting_path  export_participatory_process_user_proposals_statistic_setting_path
        # rubocop:enable Layout/ExtraSpacing
      end
    end
  end
end