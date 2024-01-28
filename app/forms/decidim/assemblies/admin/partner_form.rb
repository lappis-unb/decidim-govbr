# frozen_string_literal: true

module Decidim
  module Assemblies
    module Admin
      # A form object used to create conference members from the admin dashboard.
      class PartnerForm < Decidim::Govbr::Admin::PartnerForm
        mimic :assembly_partner

        validates :logo, passthru: {
          to: Decidim::Govbr::Partner,
          with: {
            # The partner gets its organization context through the conference
            # object which is why we need to create a dummy conference in order
            # to pass the correct organization context to the file upload
            # validators.
            partnerable: lambda do |form|
              Decidim::Assembly.new(organization: form.current_organization)
            end
          }
        }
      end
    end
  end
end