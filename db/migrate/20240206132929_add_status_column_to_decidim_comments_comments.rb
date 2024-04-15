class AddStatusColumnToDecidimCommentsComments < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_comments_comments, :status, :integer, default: 0
  end
end
