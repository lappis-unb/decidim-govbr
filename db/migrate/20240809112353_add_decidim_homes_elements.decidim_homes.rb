# This migration comes from decidim_homes (originally 20240809111842)
class AddDecidimHomesElements < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_homes_elements do |t|
      t.references :decidim_homes_home, null: false, index: { name: "index_decidim_homes_elements_on_decidim_homes_home_id" }, foreign_key: true
      t.string :element_type, null: false
      t.jsonb :properties, null: false, default: {}
    end
  end
end
