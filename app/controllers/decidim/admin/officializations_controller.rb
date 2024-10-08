# frozen_string_literal: true

module Decidim
  module Admin
    # Controller that allows managing user officializations at the admin panel.
    #
    class OfficializationsController < Decidim::Admin::ApplicationController
      include Decidim::Admin::Officializations::Filterable

      layout "decidim/admin/users"

      helper_method :user
      helper Decidim::Messaging::ConversationHelper

      def index
        enforce_permission_to :read, :officialization
        @users = filtered_collection
      end

      def new
        enforce_permission_to :create, :officialization

        @form = form(OfficializationForm).from_model(user)
      end

      def create
        enforce_permission_to :create, :officialization

        @form = form(OfficializationForm).from_params(params)

        OfficializeUser.call(@form) do
          on(:ok) do |user|
            notice = I18n.t("officializations.create.success", scope: "decidim.admin")

            redirect_to officializations_path(q: { name_or_nickname_or_email_cont: user.name }), notice: notice
          end
        end
      end

      def destroy
        enforce_permission_to :destroy, :officialization

        UnofficializeUser.call(user, current_user) do
          on(:ok) do
            notice = I18n.t("officializations.destroy.success", scope: "decidim.admin")

            redirect_to officializations_path(q: { name_or_nickname_or_email_cont: user.name }), notice: notice
          end
        end
      end

      def show_email
        enforce_permission_to :show_email, :user, user: user

        Decidim.traceability.perform_action! :show_email, user, current_user

        render :show_email, layout: false
      end

      def delete_user
        enforce_permission_to :delete_user, :user, user: user

        Decidim::Govbr::Admin::DestroyUser.call(user, current_user) do
          on(:invalid) do |reason|
            flash[:alert] = "Você não tem permissão para excluir usuários" if reason == :super_admin
            flash[:alert] = "Este usuário não pode ser excluído, pois é um administrador da organização" if reason == :target_user_is_admin
            redirect_to officializations_path
          end

          on(:error) do
            flash[:alert] = "Algo deu errado ao tentar excluir este usuário"
            redirect_to officializations_path
          end

          on(:ok) do
            flash[:success] = "A conta do usuário foi excluída com sucesso!"
            redirect_to officializations_path
          end
        end
      end

      private

      def collection
        @collection ||= current_organization.users.not_deleted.left_outer_joins(:user_moderation)
      end

      def user
        @user ||= Decidim::User.find_by(
          id: params[:user_id],
          organization: current_organization
        )
      end

      # Here we've added identities_uid_cont predicate to allow admins
      # to find users by CPF
      def search_field_predicate
        :name_or_nickname_or_email_or_identities_uid_cont
      end
    end
  end
end
