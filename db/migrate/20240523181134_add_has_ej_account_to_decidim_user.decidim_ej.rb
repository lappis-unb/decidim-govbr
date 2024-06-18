# This migration comes from decidim_ej (originally 20240518200147)
class AddHasEjAccountToDecidimUser < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_users, :has_ej_account, :boolean, default: false, null: false
  end
end
