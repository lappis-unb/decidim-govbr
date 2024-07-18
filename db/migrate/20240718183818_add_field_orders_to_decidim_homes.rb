class AddFieldOrdersToDecidimHomes < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_homes_homes, :field_orders, :jsonb, default: []
    remove_column :decidim_homes_homes, :orders, :jsonb
  end
end
