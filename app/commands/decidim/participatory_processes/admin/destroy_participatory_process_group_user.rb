# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # This command unlinks user from participatory process group by
      # destroying its user roles
      class DestroyParticipatoryProcessGroupUser < Decidim::Command
        # Public: Initializes the command
        #
        # participatory_process_group - the participatory process group to link
        # current_user - The user that is performing the action
        # user - The user to be unlinked
        def initialize(participatory_process_group, current_user, user)
          @participatory_process_group = participatory_process_group
          @current_user = current_user
          @user = user
        end

        attr_reader :participatory_process_group, :current_user, :user

        # Executes the command. Broadcasts these events:
        #
        # - :ok when destruction succeed.
        # - :invalid if user and group are not linked
        #
        # Returns nothing
        def call
          return broadcast(:invalid) if user_current_process_group != participatory_process_group

          transaction do
            destroy_current_user_roles!

            user.participatory_process_group = nil
            user.decidim_participatory_process_group_role = nil
            user.save!
          end

          broadcast(:ok)
        end

        def user_current_process_group
          user.participatory_process_group
        end

        def scoped_user_roles
          @scoped_user_roles ||= ParticipatoryProcessUserRole.where(user: user, participatory_processes: participatory_processes)
        end

        def participatory_processes
          @participatory_processes ||= participatory_process_group.participatory_processes
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
      end
    end
  end
end
