# This migration comes from decidim_ej (originally 20240613224723)
class AddEncryptedEjPasswordToDecidimUser < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_users, :encrypted_ej_password, :string
  end
end
