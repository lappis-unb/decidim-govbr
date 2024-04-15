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
        attribute :participatory_process_group_id, Integer
        attribute :needs_entity_fields, Boolean

        validates :email, :role, :participatory_process_group_id, presence: true
        validates :role, inclusion: Decidim::ParticipatoryProcessUserRole::ROLES
        validate :user_existence
        validate :user_group_membership_uniqueness

        def available_roles_for_select
          Decidim::ParticipatoryProcessUserRole::ROLES
        end

        def map_model(model)
          self.email = model.email
          self.role = model.decidim_participatory_process_group_role
        end

        private

        def user_existence
          errors.add(:email, :invalid) unless user.present?
        end

        def user_group_membership_uniqueness
          return unless user&.participatory_process_group.present?

          errors.add(:email, :taken) if user.participatory_process_group.id != participatory_process_group_id
        end

        def user
          @user ||= Decidim::User.find_by(email: email)
        end
      end
    end
  end
end
