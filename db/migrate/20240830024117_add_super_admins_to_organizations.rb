class AddSuperAdminsToOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_organizations, :super_admins, :string, array: true, default: [], index: true
  end
end
