class AddHideInMenuToComponent < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_components, :hide_in_menu, :boolean
  end
end
