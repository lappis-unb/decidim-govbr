class AddMenuLinksToOrganization < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_organizations, :menu_links, :jsonb, null: false, default: '{}'
  end
end
