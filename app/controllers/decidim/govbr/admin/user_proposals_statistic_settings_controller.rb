# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      class UserProposalsStatisticSettingsController < Decidim::Admin::ApplicationController
        def index
          enforce_permission_to :index, :user_proposals_statistic_setting

          @statistic_settings = collection
        end

        def new
          enforce_permission_to :create, :user_proposals_statistic_setting

          @form = form(UserProposalsStatisticSettingForm).instance
        end

        def create
          enforce_permission_to :create, :user_proposals_statistic_setting

          @form = form(UserProposalsStatisticSettingForm).from_params(params)

          CreateUserProposalsStatisticSetting.call(@form, current_user, current_participatory_space) do
            on(:ok) do
              flash[:notice] = I18n.t("user_proposals_statistic_settings.create.success", scope: SCOPE)
              redirect_to participatory_space_user_proposals_statistic_settings_path(current_participatory_space)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("user_proposals_statistic_settings.create.error", scope: SCOPE)
              render :new
            end
          end
        end

        def edit
          @statistic_setting = collection.find(params[:id])
          enforce_permission_to :update, :user_proposals_statistic_setting, statistic_setting: @statistic_setting
          @form = form(UserProposalsStatisticSettingForm).from_model(@statistic_setting)
        end

        def update
          @statistic_setting = collection.find(params[:id])
          enforce_permission_to :update, :user_proposals_statistic_setting, statistic_setting: @statistic_setting
          @form = form(UserProposalsStatisticSettingForm).from_params(params)

          UpdateUserProposalsStatisticSetting.call(@form, @statistic_setting) do
            on(:ok) do
              flash[:notice] = I18n.t("user_proposals_statistic_settings.update.success", scope: SCOPE)
              redirect_to participatory_space_user_proposals_statistic_settings_path(current_participatory_space)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("user_proposals_statistic_settings.update.error", scope: SCOPE)
              render :edit
            end
          end
        end

        def destroy
          @statistic_setting = collection.find(params[:id])
          enforce_permission_to :destroy, :user_proposals_statistic_setting, statistic_setting: @statistic_setting

          DestroyUserProposalsStatisticSetting.call(@statistic_setting, current_user) do
            on(:ok) do
              flash[:alert] = I18n.t("user_proposals_statistic_settings.destroy.success", scope: SCOPE)
              redirect_to participatory_space_user_proposals_statistic_settings_path(current_participatory_space)
            end
          end
        end

        def export
          enforce_permission_to :read, :user_proposals_statistic_setting
          @statistic_setting = collection.find(params[:id])

          send_data @statistic_setting.user_proposals_statistics_as_csv, filename: "#{@statistic_setting.last_generated_statistics_data_identifier}.csv"
        end

        def force_refresh
          enforce_permission_to :create, :user_proposals_statistic_setting

          begin
            @statistic_setting = collection.find(params[:id])
            @statistic_setting.refresh_data!

            flash[:notice] = "Ok"
            redirect_to participatory_space_user_proposals_statistic_settings_path(current_participatory_space)
          rescue StandardError => e
            render json: {
              'error' => e.message,
              'stacktrace' => e.backtrace
            }
          end
        end

        def participatory_space_user_proposals_statistic_settings_path(_current_participatory_space)
          raise NotImplementedError
        end

        private

        def collection
          current_participatory_space.try(:user_proposals_statistic_settings) || []
        end
      end
    end
  end
end