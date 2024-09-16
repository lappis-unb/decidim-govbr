class AddElementOrdersToDecidimHomesHomes < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_homes_homes, :element_orders, :jsonb, default: []
  end
end
