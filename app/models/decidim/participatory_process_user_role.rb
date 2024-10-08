# frozen_string_literal: true

module Decidim
  # Defines a relation between a user and a participatory process, and what
  # kind of relation does the user has.
  class ParticipatoryProcessUserRole < ApplicationRecord
    include Traceable
    include Loggable

    belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User", optional: true
    belongs_to :participatory_process, foreign_key: "decidim_participatory_process_id", class_name: "Decidim::ParticipatoryProcess", optional: true

    alias participatory_space participatory_process

    ROLES = %w(admin collaborator moderator valuator group_admin).freeze
    validates :role, inclusion: { in: ROLES }, uniqueness: { scope: [:user, :participatory_process] }
    validate :user_and_participatory_process_same_organization

    def self.log_presenter_class_for(_log)
      Decidim::ParticipatoryProcesses::AdminLog::ParticipatoryProcessUserRolePresenter
    end

    ransacker :name do
      Arel.sql(%{("decidim_users"."name")::text})
    end

    ransacker :nickname do
      Arel.sql(%{("decidim_users"."nickname")::text})
    end

    ransacker :email do
      Arel.sql(%{("decidim_users"."email")::text})
    end

    ransacker :invitation_accepted_at do
      Arel.sql(%{("decidim_users"."invitation_accepted_at")::text})
    end

    ransacker :last_sign_in_at do
      Arel.sql(%{("decidim_users"."last_sign_in_at")::text})
    end

    private

    # Private: check if the process and the user have the same organization
    def user_and_participatory_process_same_organization
      return if !participatory_process || !user

      errors.add(:participatory_process, :invalid) unless user.organization == participatory_process.organization
    end
  end
end
