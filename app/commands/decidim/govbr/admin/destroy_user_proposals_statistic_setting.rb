# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # A command with all the business logic when destroying a user proposals statistic setting
      # in the system.
      class DestroyUserProposalsStatisticSetting < Decidim::Command
        # Public: Initializes the command.
        #
        # statistic_setting - the statistic setting to destroy
        # current_user - the user performing this action
        def initialize(statistic_setting, current_user)
          @statistic_setting = statistic_setting
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          destroy_speaker!
          broadcast(:ok)
        end

        private

        attr_reader :statistic_setting, :current_user

        def destroy_speaker!
          log_information = {
            resource: {
              title: statistic_setting.name
            },
            participatory_space: {
              title: statistic_setting.participatory_space.title
            }
          }

          Decidim.traceability.perform_action!(
            "delete",
            statistic_setting,
            current_user,
            log_information
          ) do
            statistic_setting.destroy!
            statistic_setting
          end
        end
      end
    end
  end
end
