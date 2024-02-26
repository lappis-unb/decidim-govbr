# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # A form object used to create assembly partners.
      class PartnerForm < Decidim::Govbr::Admin::PartnerForm
        mimic :participatory_process_partner

        validates :logo, passthru: {
          to: Decidim::Govbr::Partner,
          with: {
            # The partner gets its organization context through the conference
            # object which is why we need to create a dummy conference in order
            # to pass the correct organization context to the file upload
            # validators.
            partnerable: lambda do |form|
              Decidim::ParticipatoryProcess.new(organization: form.current_organization)
            end
          }
        }
      end
    end
  end
end