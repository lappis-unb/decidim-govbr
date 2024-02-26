# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # A command with all the business logic when updating a partnerable
      # partner in the system.
      class UpdatePartner < Decidim::Command
        include ::Decidim::AttachmentAttributesMethods

        # Public: Initializes the command.
        #
        # form - A form object with the params.
        # partnerable_partner - The partnerable partner to update
        def initialize(form, partnerable_partner)
          @form = form
          @partnerable_partner = partnerable_partner
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?
          return broadcast(:invalid) unless partnerable_partner

          # We are going to assign the attributes only to handle the validation of the avatar before accessing
          # `update_partnerable_partner!` which uses `update!`. Without this step, the image validation may render
          # an ActiveRecord::RecordInvalid error
          # After we assign and check if the object is valid, we reload the model to let it be handled the old way
          # If there is an error we add the error to the form
          partnerable_partner.assign_attributes(attributes)
          if partnerable_partner.valid?
            partnerable_partner.reload

            update_partnerable_partner!
            broadcast(:ok)
          else
            form.errors.add(:logo, partnerable_partner.errors[:logo]) if partnerable_partner.errors.include? :logo

            broadcast(:invalid)
          end
        end

        private

        attr_reader :form, :partnerable_partner

        def attributes
          form.attributes.slice(
            "name",
            "weight",
            "partner_type",
            "link"
          ).symbolize_keys.merge(
            attachment_attributes(:logo)
          )
        end

        def update_partnerable_partner!
          log_info = {
            resource: {
              title: partnerable_partner.name
            },
            participatory_space: {
              title: partnerable_partner.partnerable.title
            }
          }

          Decidim.traceability.update!(
            partnerable_partner,
            form.current_user,
            attributes,
            log_info
          )
        end
      end
    end
  end
end
