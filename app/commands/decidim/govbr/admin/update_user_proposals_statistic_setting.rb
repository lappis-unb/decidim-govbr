# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # A command with all the business logic when updating a participatory space
      # statistic setting in the system
      class UpdateUserProposalsStatisticSetting < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        # statistic_setting - The statistic setting to update
        def initialize(form, statistic_setting)
          @form = form
          @statistic_setting = statistic_setting
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?
          return broadcast(:invalid) unless statistic_setting

          transaction do
            update_statistic_setting!
          end

          broadcast(:ok)
        end

        private

        attr_reader :form, :statistic_setting

        def update_statistic_setting!
          log_information = {
            resource: {
              title: statistic_setting.name
            },
            participatory_space: {
              title: statistic_setting.participatory_space.title
            }
          }

          Decidim.traceability.update!(
            statistic_setting,
            form.current_user,
            form.attributes.slice(
              "name",
              "proposals_done_weight",
              "comments_done_weight",
              "votes_done_weight",
              "follows_done_weight",
              "votes_received_weight",
              "comments_received_weight",
              "follows_received_weight",
              "users_to_be_exported"
            ).symbolize_keys,
            log_information
          )
        end
      end
    end
  end
end
