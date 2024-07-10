class AddEmmphasisLinkHomeComponent < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_homes_homes, :emphasis_link, :string
  end
end
