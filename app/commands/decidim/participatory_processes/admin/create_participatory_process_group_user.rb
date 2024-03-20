# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # This command links user to participatory process group by
      # creating roles
      class CreateParticipatoryProcessGroupUser < Decidim::Command
        # Public: Initializes the command
        #
        # participatory_process_group - the participatory process group to link
        # current_user - the current user that is perfoming the action
        # form - A form object containing user information and relationship, i.e.: user role
        def initialize(participatory_process_group, current_user, form)
          @participatory_process_group = participatory_process_group
          @current_user = current_user
          @form = form
        end

        attr_reader :participatory_process_group, :current_user, :form

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if form has invalid data, or participatory process group is blank, or user already belong to a group
        # - :taken when user already belongs to a process group
        #
        # Returns nothing
        def call
          return broadcast(:invalid) if form.invalid? || participatory_process_group.blank?
          return broadcast(:taken, user_current_process_group.title[current_locale]) if user_current_process_group.present?

          transaction do
            update_user_roles!

            user.participatory_process_group = participatory_process_group
            user.decidim_participatory_process_group_role = form.role
            user.save!
          end

          broadcast(:ok)
        end

        private

        def user_current_process_group
          user.participatory_process_group
        end

        def user
          @user ||= Decidim::User.find_by(email: form.email)
        end

        def scoped_user_roles
          @scoped_user_roles ||= ParticipatoryProcessUserRole.where(user: user, participatory_process: participatory_processes)
        end

        def participatory_processes
          @participatory_processes ||= participatory_process_group.participatory_processes
        end

        # Create or update existing roles according to group user membership. I.e., if the participatory process group
        # have two processes inside of it, and user already has a role for one of them, this method creates
        # a new participatory process user role and updates the existing one with the specified role privilleges
        #
        def update_user_roles!
          participatory_processes.each do |participatory_process|
            user_role = scoped_user_roles.detect { |scoped_user_role| scoped_user_role.decidim_participatory_process_id == participatory_process.id }
            if user_role
              Decidim.traceability.update!(
                user_role,
                current_user,
                {
                  role: form.role.to_sym
                },
                resource: {
                  title: user.name
                }
              )
            else
              Decidim.traceability.create!(
                Decidim::ParticipatoryProcessUserRole,
                current_user,
                {
                  role: form.role.to_sym,
                  user: user,
                  participatory_process: participatory_process
                },
                resource: {
                  title: user.name
                }
              )
            end
          end
        end

        def destroy_current_user_roles!
          scoped_user_roles.each do |user_role|
            Decidim.traceability.perform_action!(
              "delete",
              user_role,
              current_user,
              resource: {
                title: user_role.user.name
              }
            ) do
              user_role.destroy!
              user_role
            end
          end
        end

        def create_new_user_roles!
          participatory_processes.each do |participatory_process|
            role_params = {
              role: form.role.to_sym,
              user: user,
              participatory_process: participatory_process
            }

            Decidim.traceability.create!(
              Decidim::ParticipatoryProcessUserRole,
              current_user,
              role_params,
              resource: {
                title: user.name
              }
            )
          end
        end
      end
    end
  end
end
