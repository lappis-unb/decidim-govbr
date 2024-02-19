class AddPluralizedNameToDecidimComponents < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_components, :pluralized_name, :jsonb
  end
end
