# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # This command updates user participation on a participatory process group by
      # changing their roles
      class UpdateParticipatoryProcessGroupUser < Decidim::Command
        # Public: Initializes the command
        #
        # current_user - the current user that is perfoming the action
        # form - A form object containing user information and relationship, i.e.: user role
        def initialize(current_user, form)
          @current_user = current_user
          @form = form
        end

        attr_reader :current_user, :form

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if form has invalid data, or participatory process group is blank
        #
        # Returns nothing
        def call
          return broadcast(:invalid) if form.invalid? || participatory_process_group.blank?

          transaction do
            update_existing_user_roles!
            create_missing_user_roles!

            user.participatory_process_group = participatory_process_group
            user.decidim_participatory_process_group_role = form.role
            user.save!
          end

          broadcast(:ok)
        end

        private

        def participatory_process_group
          @participatory_process_group ||= ParticipatoryProcessGroup.find_by(id: form.participatory_process_group_id)
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

        # Update existing user roles according to the specified role on the form
        #
        def update_existing_user_roles!
          scoped_user_roles.each do |user_role|
            Decidim.traceability.update!(
              user_role,
              current_user,
              {
                role: form.role.to_sym
              },
              {
                resource: {
                  title: user.name
                }
              }
            )
          end
        end

        # Returns the difference between all the processes that belong to the participatory group and the processes that
        # the user has roles on them. I.e. the participatory process group processes that the user
        # does not have a role yet.
        #
        def remaining_processes
          participatory_processes - scoped_user_roles.map(&:participatory_process)
        end

        # Create missing roles for this user if there are processes that user doesn't participate yet
        #
        def create_missing_user_roles!
          remaining_processes.each do |process|
            Decidim.traceability.create!(
              ParticipatoryProcessUserRole,
              current_user,
              {
                participatory_process: process,
                user: user,
                role: form.role.to_sym
              },
              {
                resource: {
                  title: user.name
                }
              }
            )
          end
        end
      end
    end
  end
end
