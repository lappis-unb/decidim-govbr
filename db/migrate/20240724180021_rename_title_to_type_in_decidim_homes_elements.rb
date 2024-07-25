class RenameTitleToTypeInDecidimHomesElements < ActiveRecord::Migration[6.1]
  def change
    rename_column :decidim_homes_elements, :title, :type
  end
end
