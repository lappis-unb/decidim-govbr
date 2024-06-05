class AddEnableCommentsAttachmentToComponents < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_components, :enable_comments_attachment, :boolean, default: false
  end
end
