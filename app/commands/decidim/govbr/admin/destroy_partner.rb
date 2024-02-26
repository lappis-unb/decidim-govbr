# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # A command with all the business logic when destroying an partnerable
      # partner in the system.
      class DestroyPartner < Decidim::Command
        # Public: Initializes the command.
        #
        # partnerable_partner - the Partner to destroy
        # current_user - the user performing this action
        def initialize(partnerable_partner, current_user)
          @partnerable_partner = partnerable_partner
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          destroy_partner!
          broadcast(:ok)
        end

        private

        attr_reader :partnerable_partner, :current_user

        def destroy_partner!
          log_info = {
            resource: {
              title: partnerable_partner.name
            },
            participatory_space: {
              title: partnerable_partner.partnerable.title
            }
          }

          Decidim.traceability.perform_action!(
            "delete",
            partnerable_partner,
            current_user,
            log_info
          ) do
            partnerable_partner.destroy!
            partnerable_partner
          end
        end
      end
    end
  end
end
