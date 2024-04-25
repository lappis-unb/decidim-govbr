class AddExtraFieldsToDecidimUser < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_users, :entity_fields, :jsonb
    add_column :decidim_users, :needs_entity_fields, :boolean, default: false
  end
end
