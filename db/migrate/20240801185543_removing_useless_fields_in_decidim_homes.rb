class RemovingUselessFieldsInDecidimHomes < ActiveRecord::Migration[6.1]
  def change
    remove_column :decidim_homes_homes, :banner
    remove_column :decidim_homes_homes, :digital_stage
    remove_column :decidim_homes_homes, :organize_stage
    remove_column :decidim_homes_homes, :schedule
    remove_column :decidim_homes_homes, :common_questions
    remove_column :decidim_homes_homes, :support_material
    remove_column :decidim_homes_homes, :statistics
    remove_column :decidim_homes_homes, :news
    remove_column :decidim_homes_homes, :news_id
    remove_column :decidim_homes_homes, :header_title
    remove_column :decidim_homes_homes, :header_subtitle
    remove_column :decidim_homes_homes, :steps_title
    remove_column :decidim_homes_homes, :steps_subtitle
    remove_column :decidim_homes_homes, :emphasis_title
    remove_column :decidim_homes_homes, :emphasis_subtitle
    remove_column :decidim_homes_homes, :emphasis_button_text
    remove_column :decidim_homes_homes, :participation_title
    remove_column :decidim_homes_homes, :participation_subtitle
    remove_column :decidim_homes_homes, :map_able
    remove_column :decidim_homes_homes, :emphasis_link
    remove_column :decidim_homes_homes, :meetings_map
    remove_column :decidim_homes_homes, :meeting_id
    remove_column :decidim_homes_homes, :reverse_call_to_action
    rename_column :decidim_homes_homes, :field_orders, :element_orders
  end
end
