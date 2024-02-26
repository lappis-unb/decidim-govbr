# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # A command with all the business logic when creating a new
      # media link for a participatory space in the system.
      class CreateMediaLink < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        # participatory_space - The Participatory Space that will hold the speaker
        def initialize(form, current_user, participatory_space)
          @form = form
          @current_user = current_user
          @participatory_space = participatory_space
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            create_media_link!
          end

          broadcast(:ok)
        end

        private

        attr_reader :form, :participatory_space, :current_user

        def create_media_link!
          log_info = {
            resource: {
              title: form.title
            },
            participatory_space: {
              title: participatory_space.title
            }
          }

          @media_link = Decidim.traceability.create!(
            Decidim::Govbr::MediaLink,
            current_user,
            form.attributes.slice(
              "title",
              "link",
              "weight",
              "date"
            ).symbolize_keys.merge(
              participatory_space: participatory_space
            ),
            log_info
          )
        end
      end
    end
  end
end
