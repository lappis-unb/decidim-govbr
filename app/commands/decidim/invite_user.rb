# frozen_string_literal: true

module Decidim
  # A command with the business logic to invite a user to an organization.
  class InviteUser < Decidim::Command
    # Public: Initializes the command.
    #
    # form - A form object with the params.
    def initialize(form)
      @form = form
    end

    def call
      return broadcast(:invalid) if form.invalid?

      if user.present?
        update_user
      else
        invite_user
      end

      broadcast(:ok, user)
    end

    private

    attr_reader :form

    def user
      @user ||= Decidim::User.where(organization: form.organization).where(email: form.email.downcase).first
    end

    def update_user
      user.admin = form.role == "admin"
      user.roles << form.role if form.role != "admin"
      user.roles = user.roles.uniq.compact
      user.save!
      send_notification_email_to_existing_user
    end

    def send_notification_email_to_existing_user
      return unless form.role == "admin"
      Decidim::Govbr::PromotedToAdminMailer.notification(user).deliver_later
    end

    def participatory_process_group
      @participatory_process_group ||= ParticipatoryProcessGroup.find_by(id: form.participatory_process_group_id)
    end

    def participatory_processes
      @participatory_processes ||= participatory_process_group.participatory_processes
    end

    def invite_user
      @user = Decidim::User.new(
        name: form.name,
        email: form.email.downcase,
        nickname: UserBaseEntity.nicknamize(form.name, organization: form.organization),
        organization: form.organization,
        admin: form.role == "admin",
        roles: form.role == "admin" ? [] : [form.role].compact
      )
      @user.invite!(
        form.invited_by,
        invitation_instructions: form.invitation_instructions
      )

      return unless form.role == 'group_admin'
      participatory_processes.each do |participatory_process|
        Decidim.traceability.create!(
          Decidim::ParticipatoryProcessUserRole,
          form.current_user,
          {
            role: :admin,
            user: @user,
            participatory_process: participatory_process
          },
          resource: {
            title: @user.name
          }
        )
      end
      
      user.participatory_process_group = participatory_process_group
      user.decidim_participatory_process_group_role = form.role
      user.save!
    end
  end
end
