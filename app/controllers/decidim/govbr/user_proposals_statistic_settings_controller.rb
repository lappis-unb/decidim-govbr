module Decidim
  module Govbr
    class UserProposalsStatisticSettingsController < Decidim::Admin::ApplicationController
      before_action :authorize_user
      before_action :find_participatory_space, only: [:force_refresh, :create, :export_user_data]

      def index
        @statistic_settings = Decidim::Govbr::UserProposalsStatisticSetting.all
      end

      def force_refresh
        statistic_setting = find_statistic_setting

        if statistic_setting
          refresh_statistic_setting(statistic_setting)
        else
          render_not_found_error
        end
      end

      def create
        statistic_setting = find_statistic_setting

        if statistic_setting
          render json: { 'ERROR' => "Statistic for the participatory space #{params[:slug]} already exists." }
        else
          create_statistic_setting
        end
      end

      def export_user_data
        statistic_setting = find_statistic_setting

        if statistic_setting
          export_statistic_data(statistic_setting)
        else
          render_no_reports_error
        end
      end

      private

      def authorize_user
        enforce_permission_to :read, :admin_user
      end

      def find_participatory_space
        @participatory_space ||= Decidim::ParticipatoryProcess.find_by(slug: params[:slug]) ||
                                 Decidim::Assembly.find_by(slug: params[:slug]) ||
                                 Decidim::Conference.find_by(slug: params[:slug])
      end

      def find_statistic_setting
        Decidim::Govbr::UserProposalsStatisticSetting.find_by(
          decidim_participatory_space_type: @participatory_space.class.to_s,
          decidim_participatory_space_id: @participatory_space.id
        )
      end

      def refresh_statistic_setting(statistic_setting)
        statistic_setting.refresh_data!
        render json: { success: 'Data refreshed' }
      rescue StandardError => e
        render_error(e)
      end

      def create_statistic_setting
        Decidim::Govbr::UserProposalsStatisticSetting.create!(
          decidim_participatory_space_type: @participatory_space.class.to_s,
          decidim_participatory_space_id: @participatory_space.id,
          name: params[:slug]
        )
        render json: { 'success' => 'Resource created successfully' }
      rescue StandardError => e
        render_error(e)
      end

      def export_statistic_data(statistic_setting)
        user_data = statistic_setting.user_proposals_statistics

        if user_data.present?
          send_data statistic_setting.user_proposals_statistics_as_csv, filename: "report-#{Date.today}.csv"
        else
          render json: {
            'INFO' => "There is no compiled data for the participatory space '#{params[:slug]}' yet. Last time updated was: #{statistic_setting.updated_at}"
          }
        end
      rescue StandardError => e
        render_error(e)
      end

      def render_not_found_error
        render json: { 'ERROR' => "Statistic setting not found for the participatory space '#{params[:slug]}'." }
      end

      def render_no_reports_error
        available_reports = Decidim::ParticipatoryProcess.where(
          id: Decidim::Govbr::UserProposalsStatisticSetting.pluck(:decidim_participatory_space_id)
        ).map(&:slug)

        render json: {
          'ERROR' => "There is no available reports for the participatory space '#{params[:slug]}'. Available reports are: #{available_reports.try(:join, ', ')}"
        }
      end

      def render_error(exception)
        render json: { 'error' => exception.message, 'stacktrace' => exception.backtrace }
      end
    end
  end
end
