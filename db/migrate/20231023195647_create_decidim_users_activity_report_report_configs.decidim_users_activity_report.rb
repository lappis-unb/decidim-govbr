# This migration comes from decidim_users_activity_report (originally 20231023194400)
class CreateDecidimUsersActivityReportReportConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_users_activity_report_report_configs do |t|
      t.string :name
      t.integer :recurrence

      t.timestamps
    end
  end
end
