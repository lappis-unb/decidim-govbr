module Decidim
  module Govbr
    class UserProposalsStatisticSettingsController < Decidim::Admin::ApplicationController
      def export_user_data
        user_data = Decidim::Govbr::UserProposalsStatisticSetting.first.user_proposals_statistics.order(score: :desc).limit(500)
        render :json => user_data.as_json(except: [:id, :created_at, :updated_at, :user_proposals_statistic_setting_id])
      end
    end
  end
end