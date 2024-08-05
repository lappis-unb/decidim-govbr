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
  end
end
