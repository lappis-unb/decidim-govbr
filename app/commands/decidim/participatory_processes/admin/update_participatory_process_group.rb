# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # A command with all the business logic when creating a new participatory
      # process group in the system.
      class UpdateParticipatoryProcessGroup < Decidim::Command
        include ::Decidim::AttachmentAttributesMethods

        # Public: Initializes the command.
        #
        # participatory_process_group - the ParticipatoryProcessGroup to update
        # form - A form object with the params.
        def initialize(participatory_process_group, form)
          @participatory_process_group = participatory_process_group
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          @processes_to_revoke_roles = @participatory_process_group.participatory_processes - participatory_processes
          @processes_to_grant_roles = participatory_processes - @participatory_process_group.participatory_processes

          update_participatory_process_group

          unless @participatory_process_group.valid?
            form.errors.add(:hero_image, @participatory_process_group.errors[:hero_image]) if @participatory_process_group.errors.include? :hero_image
            broadcast(:invalid)
          end

          update_users_roles!

          broadcast(:ok, @participatory_process_group)
        end

        private

        attr_reader :form, :participatory_process_group

        def update_users_roles!
          revoke_stale_roles!
          grant_new_roles!
        end

        def revoke_stale_roles!
          Decidim::ParticipatoryProcessUserRole.where(user: users, participatory_process: @processes_to_revoke_roles).each do |user_role|
            Decidim.traceability.perform_action!(
              "delete",
              user_role,
              form.current_user,
              resource: {
                title: user_role.user.name
              }
            ) do
              user_role.destroy!
              user_role
            end
          end
        end

        def grant_new_roles!
          users.each do |user|
            @processes_to_grant_roles.each do |process|
              # If user already have a role for this process, what am I supposed to do? Panic
              next if user_already_has_role?(user, process)

              role_params = {
                role: user.decidim_participatory_process_group_role.to_sym,
                user: user,
                participatory_process: process
              }
              Decidim.traceability.create!(
                Decidim::ParticipatoryProcessUserRole,
                form.current_user,
                role_params,
                resource: {
                  title: user.name
                }
              )
            end
          end
        end

        def users_roles
          @users_roles ||= Decidim::ParticipatoryProcessUserRole.where(user: users)
        end

        def user_already_has_role?(user, process)
          process.id.in?(users_roles.select { |user_role| user_role.decidim_user_id == user.id }.map(&:decidim_participatory_process_id))
        end

        def users
          @users ||= Decidim::User.where(participatory_process_group: participatory_process_group)
        end

        def update_participatory_process_group
          Decidim.traceability.perform_action!(
            "update",
            @participatory_process_group,
            form.current_user
          ) do
            @participatory_process_group.assign_attributes(attributes)
            @participatory_process_group.save! if @participatory_process_group.valid?
          end
        end

        def attributes
          {
            title: form.title,
            description: form.description,
            hashtag: form.hashtag,
            group_url: form.group_url,
            participatory_processes: participatory_processes,
            developer_group: form.developer_group,
            local_area: form.local_area,
            meta_scope: form.meta_scope,
            participatory_scope: form.participatory_scope,
            participatory_structure: form.participatory_structure,
            target: form.target,
            promoted: form.promoted,
            decidim_area_id: form.decidim_area_id
          }.merge(attachment_attributes(:hero_image))
        end

        def participatory_processes
          Decidim::ParticipatoryProcess.where(id: form.participatory_process_ids)
        end
      end
    end
  end
end
