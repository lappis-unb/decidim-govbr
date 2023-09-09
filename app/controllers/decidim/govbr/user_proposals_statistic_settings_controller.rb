module Decidim
  module Govbr
    class UserProposalsStatisticSettingsController < Decidim::Admin::ApplicationController
      def index
        enforce_permission_to :read, :admin_user

        @statistic_settings = Decidim::Govbr::UserProposalsStatisticSetting.all
      end

      def force_refresh
        enforce_permission_to :read, :admin_user

        begin
          participatory_space = find_participatory_space(params[:slug])
          statistic_setting = Decidim::Govbr::UserProposalsStatisticSetting.where(
            decidim_participatory_space_type: participatory_space.class.to_s,
            decidim_participatory_space_id: participatory_space.id
          ).first

          statistic_setting.refresh_data!

          render json: { success: 'Data refreshed' }

        rescue StandardError => e
          render json: {
            'error' => e.message,
            'stacktrace' => e.backtrace
          }
        end
      end

      def create
        enforce_permission_to :read, :admin_user

        begin
          participatory_space = find_participatory_space(params[:slug])
          statistic_setting = Decidim::Govbr::UserProposalsStatisticSetting.where(
            decidim_participatory_space_type: participatory_space.class.to_s,
            decidim_participatory_space_id: participatory_space.id
          ).first

          if statistic_setting.blank?
            Decidim::Govbr::UserProposalsStatisticSetting.create!(
              decidim_participatory_space_type: participatory_space.class.to_s,
              decidim_participatory_space_id: participatory_space.id,
              name: params[:slug]
            )

            render json: {
              'success' => 'Resource created successfully'
            }
          else
            render json: {
              'ERROR' => "Statistic for the participatory space #{params[:slug]} already exists."
            }
          end

        rescue StandardError => e
          render json: {
            'error' => e.message,
            'stacktrace' => e.backtrace
          }
        end
      end

      def export_user_data
        enforce_permission_to :read, :admin_user

        begin
          participatory_space = find_participatory_space(params[:slug])

          statistic_setting = Decidim::Govbr::UserProposalsStatisticSetting.where(
            decidim_participatory_space_type: participatory_space.class.to_s,
            decidim_participatory_space_id: participatory_space.id
          ).first

          unless statistic_setting.blank?
            user_data = statistic_setting.user_proposals_statistics

            unless user_data.blank?
              send_data statistic_setting.user_proposals_statistics_as_csv, filename: "report-#{Date.today}.csv"
            else
              render json: {
                'INFO' =>
                  <<-T.squish
                  There is no compiled data the participatory space '#{params[:slug]}' yet.
                  Last time updated was: #{statistic_setting.updated_at}
                  T
                }
            end
          else
            available_reports = Decidim::ParticipatoryProcess.where(
              id: Decidim::Govbr::UserProposalsStatisticSetting.pluck(:decidim_participatory_space_id)
            ).map(&:slug)

            render json: {
              'ERROR' =>
                <<-T.squish
                There is no available reports for the participatory space '#{params[:slug]}'.
                Available reports are: #{available_reports.try(:join, ', ')}
                T
              }
          end
        rescue StandardError => e
          render json: {
            'error' => e.message,
            'stacktrace' => e.backtrace
          }
        end
      end

      private

      def find_participatory_space(slug)
        Decidim::ParticipatoryProcess.find_by(slug: slug) ||
        Decidim::Assembly.find_by(slug: slug) ||
        Decidim::Conference.find_by(slug: slug)
      end
    end
  end
end