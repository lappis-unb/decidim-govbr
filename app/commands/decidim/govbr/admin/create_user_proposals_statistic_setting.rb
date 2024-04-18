# fronzen_string_literal: true

module Decidim
  module Govbr
    module Admin
      class CreateUserProposalsStatisticSetting < Decidim::Command
        def initialize(form, current_user, participatory_space)
          @form = form
          @current_user = current_user
          @participatory_space = participatory_space
        end

        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            create_user_proposals_statistic_setting!
          end

          broadcast(:ok)
        end

        private

        attr_reader :form, :current_user, :participatory_space

        def create_user_proposals_statistic_setting!
          log_information = {
            resource: {
              title: form.name
            },
            participatory_space: {
              title: participatory_space.title
            }
          }

          Decidim.traceability.create!(
            Decidim::Govbr::UserProposalsStatisticSetting,
            current_user,
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
            ).symbolize_keys.merge(
              decidim_participatory_space: participatory_space
            ),
            log_information
          )
        end
      end
    end
  end
end