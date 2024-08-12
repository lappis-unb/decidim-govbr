class RemoveDecidimHomesElementsColums < ActiveRecord::Migration[6.1]
  def change
    drop_table :decidim_homes_elements
  end
end
