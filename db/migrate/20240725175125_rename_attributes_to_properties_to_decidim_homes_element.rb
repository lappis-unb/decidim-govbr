class RenameAttributesToPropertiesToDecidimHomesElement < ActiveRecord::Migration[6.1]
  def change
    rename_column :decidim_homes_elements, :attributes, :properties
  end
end
