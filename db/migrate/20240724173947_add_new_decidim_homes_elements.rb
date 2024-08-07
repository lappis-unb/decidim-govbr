class AddNewDecidimHomesElements < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_homes_elements do |t|
      t.references :decidim_homes_home, null: false, index: { name: "index_decidim_homes_elements_on_decidim_homes_home_id" }, foreign_key: true
      t.string :title, null: false
      t.jsonb :body
    end
  end
end
