# This migration comes from decidim_ej (originally 20240711135204)
class AddEjExternalIdentifierToDecidimUser < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_users, :ej_external_identifier, :string
    add_index :decidim_users, :ej_external_identifier
  end
end
