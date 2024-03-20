class AddMenuNameToDecidimComponent < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_components, :menu_name, :jsonb
  end
end
