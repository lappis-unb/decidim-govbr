# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # A command with all the business logic when creating a new partner
      # in the system.
      class CreatePartner < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        # partnerable - The partnerable that will hold the speaker
        def initialize(form, current_user, partnerable)
          @form = form
          @current_user = current_user
          @partnerable = partnerable
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          if partnerable_partner.valid?
            transaction do
              create_partner!
            end

            broadcast(:ok)
          else
            form.errors.add(:logo, partnerable_partner.errors[:logo]) if partnerable_partner.errors.include? :logo

            broadcast(:invalid)
          end
        end

        private

        attr_reader :form, :partnerable, :current_user

        def create_partner!
          log_info = {
            resource: {
              title: form.name
            },
            participatory_space: {
              title: partnerable.title
            }
          }

          @partner = Decidim.traceability.create!(
            Decidim::Govbr::Partner,
            form.current_user,
            attributes,
            log_info
          )
        end

        def partnerable_partner
          return @partnerable_partner if defined?(@partnerable_partner)

          @partnerable_partner = partnerable.partners.build
          @partnerable_partner.partnerable = partnerable
          @partnerable_partner.assign_attributes(attributes)
          @partnerable_partner
        end

        def attributes
          { partnerable: partnerable }.merge(
            form.attributes.slice(
              "name",
              "weight",
              "link",
              "partner_type",
              "logo",
              "remove_avatar"
            ).symbolize_keys
          )
        end
      end
    end
  end
end
