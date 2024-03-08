# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # A form object used to create participatory process group user from the admin
      # panel.
      #
      class ParticipatoryProcessGroupUserForm < Form
        attribute :email, String
        attribute :role, String

        validates :role, inclusion: Decidim::ParticipatoryProcessUserRole::ROLES

        def map_model(model)
          self.email = model.email
          self.role = model.decidim_participatory_process_group_role
        end
      end
    end
  end
end
