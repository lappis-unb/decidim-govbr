class AddStatisticsDataUpdatedAtToUserProposalsStatisticSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_govbr_user_proposals_statistic_settings, :statistics_data_updated_at, :datetime, precision: 6
  end
end
