class RenameTypeToElementTypeInDecidimHomesElements < ActiveRecord::Migration[6.1]
  def change
    rename_column :decidim_homes_elements, :type, :element_type
  end
end
