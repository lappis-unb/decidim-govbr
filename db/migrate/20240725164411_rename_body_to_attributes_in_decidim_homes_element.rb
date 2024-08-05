class RenameBodyToAttributesInDecidimHomesElement < ActiveRecord::Migration[6.1]
  def change
    rename_column :decidim_homes_elements, :body, :attributes
  end
end
