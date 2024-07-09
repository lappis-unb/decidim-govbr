class NewHomeComponentAttributes < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_homes_homes, :header_title, :string
    add_column :decidim_homes_homes, :header_subtitle, :string
    add_column :decidim_homes_homes, :steps_title, :string
    add_column :decidim_homes_homes, :steps_subtitle, :string
    add_column :decidim_homes_homes, :emphasis_title, :string
    add_column :decidim_homes_homes, :emphasis_subtitle, :string
    add_column :decidim_homes_homes, :emphasis_button_text, :string
    add_column :decidim_homes_homes, :participation_title, :string
    add_column :decidim_homes_homes, :participation_subtitle, :string
    add_column :decidim_homes_homes, :map_able, :boolean, default: false
  end
end
