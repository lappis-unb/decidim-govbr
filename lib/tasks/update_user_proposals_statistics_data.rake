namespace :decidim do
  namespace :govbr do
    desc 'Rebuild all user proposals statistic data'
    task update_user_proposals_statistics_data: :environment do
      Decidim::Govbr::UserProposalsStatisticSetting.find_each do |statistic_setting|
        statistic_setting.refresh_data!
      end
    end
  end
end