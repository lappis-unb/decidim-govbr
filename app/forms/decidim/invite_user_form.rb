# frozen_string_literal: true

module Decidim
  # A form object used to invite users to an organization.
  #
  class InviteUserForm < Form
    mimic :user

    include Decidim::TranslatableAttributes

    attribute :email, String
    attribute :name, String
    attribute :invitation_instructions, String
    attribute :organization, Decidim::Organization
    attribute :invited_by, Decidim::User
    attribute :role, String
    attribute :participatory_process_group_id, Integer

    validates :email, :name, :organization, :invitation_instructions, presence: true
    validates :role, inclusion: { in: Decidim::User::Roles.all }

    validates :name, format: { with: /\A(?!.*[<>?%&\^*#@()\[\]=+:;"{}\\|])/ }
    validate :admin_uniqueness

    def email
      super&.downcase
    end

    def organization
      super || current_organization
    end

    def invited_by
      super || current_user
    end

    def available_roles_for_select
      Decidim::User::Roles.all.map do |role|
        [
          I18n.t("models.user.fields.roles.#{role}", scope: "decidim.admin"),
          role
        ]
      end
    end

    def available_processes_group_for_select
      ParticipatoryProcessGroup.all.map do |process_group|
        [
          translated_attribute(process_group.title),
          process_group.id
        ]
      end
    end

    private

    def admin_uniqueness
      errors.add(:email, :taken) if organization.admins.exists?(email: email)
    end
  end
end
