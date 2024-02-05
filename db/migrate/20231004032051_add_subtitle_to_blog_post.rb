class AddSubtitleToBlogPost < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_blogs_posts, :subtitle, :jsonb
  end
end
