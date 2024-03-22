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

        validates :email, :role, presence: true
        validates :role, inclusion: Decidim::ParticipatoryProcessUserRole::ROLES
        validate :user_existence
        validate :user_group_membership_uniqueness

        def available_roles_for_select
          Decidim::ParticipatoryProcessUserRole::ROLES
        end

        private

        def user_existence
          errors.add(:email, :invalid) unless user.present?
        end

        def user_group_membership_uniqueness
          errors.add(:email, :taken) if user&.participatory_process_group.present?
        end

        def user
          @user ||= Decidim::User.find_by(email: email)
        end

        def map_model(model)
          self.email = model.email
          self.role = model.decidim_participatory_process_group_role
        end
      end
    end
  end
end
