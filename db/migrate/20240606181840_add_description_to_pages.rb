class AddDescriptionToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_pages_pages, :description, :string
  end
end
