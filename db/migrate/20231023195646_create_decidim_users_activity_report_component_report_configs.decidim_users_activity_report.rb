# This migration comes from decidim_users_activity_report (originally 20231023193009)
class CreateDecidimUsersActivityReportComponentReportConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_users_activity_report_component_report_configs do |t|
      t.text :used_fields
      t.string :type

      t.timestamps
    end

    add_reference :decidim_users_activity_report_component_report_configs, :component, index: { name: 'decidim_component_report_config_idx' }
    add_reference :decidim_users_activity_report_component_report_configs, :report_config, index: { name: 'report_config_component_report_config_idx' }
  end
end
