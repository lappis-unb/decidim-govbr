# This migration comes from decidim_ej (originally 20231004135733)
class AddDecidimComponentIdColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_ej_ej_clients, :decidim_component_id, :integer
  end
end
