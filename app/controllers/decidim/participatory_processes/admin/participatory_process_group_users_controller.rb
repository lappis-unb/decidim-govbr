# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # Controller to handle participatory process group users creation and destruction
      #
      class ParticipatoryProcessGroupUsersController < Decidim::ParticipatoryProcesses::Admin::ApplicationController
        layout "decidim/admin/participatory_process_group"

        helper_method :participatory_process_group

        def index
          enforce_permission_to :read, :process_user_role

          @users = collection
        end

        def new
          enforce_permission_to :create, :process_user_role

          @form = form(ParticipatoryProcessGroupUserForm).instance
        end

        def edit
          enforce_permission_to :update, :process_user_role

          @user = collection.find(params[:id])
          @form = form(ParticipatoryProcessGroupUserForm).from_model(@user)
        end

        def create
          enforce_permission_to :create, :process_user_role

          @form = form(ParticipatoryProcessGroupUserForm).from_params(params)
          CreateParticipatoryProcessGroupUser.call(participatory_process_group, current_user, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("participatory_process_group_users.create.success", scope: "decidim.admin")
              redirect_to main_app.participatory_process_group_users_path(participatory_process_group)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("participatory_process_group_users.create.error", scope: "decidim.admin")
              render :new
            end

            on(:taken) do |group_name|
              flash[:alert] = I18n.t("participatory_process_group_users.create.taken", scope: "decidim.admin", group_name: group_name)
              render :new
            end
          end
        end

        def update
          enforce_permission_to :update, :process_user_role

          @user = collection.find(params[:id])
          UpdateParticipatoryProcessGroupUser.call(participatory_process_group, current_user, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("participatory_process_group_users.update.success", scope: "decidim.admin")
              redirect_to main_app.participatory_process_group_users_path(participatory_process_group)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("participatory_process_group_users.update.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def destroy
          enforce_permission_to :create, :process_user_role

          @user = collection.find(params[:id])
          DestroyParticipatoryProcessGroupUser.call(participatory_process_group, current_user, @user) do
            on(:ok) do
              flash[:notice] = I18n.t("participatory_process_group_users.destroy.success", scope: "decidim.admin")
              redirect_to main_app.participatory_process_group_users_path(participatory_process_group)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("participatory_process_group_users.destroy.error", scope: "decidim.admin")
              redirect_to main_app.participatory_process_group_users_path(participatory_process_group)
            end
          end
        end

        private

        def participatory_process_group
          @participatory_process_group ||= OrganizationParticipatoryProcessGroups.new(current_user.organization).query.find(params[:participatory_process_group_id])
        end

        def collection
          @collection ||= Decidim::User.where(participatory_process_group: participatory_process_group)
        end
      end
    end
  end
end