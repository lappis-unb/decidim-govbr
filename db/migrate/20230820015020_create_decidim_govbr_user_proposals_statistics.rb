class CreateDecidimGovbrUserProposalsStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_govbr_user_proposals_statistics do |t|
      t.bigint :decidim_user_id, null: false
      t.string :decidim_user_name
      t.integer :proposals_done
      t.integer :comments_done
      t.integer :votes_dones
      t.integer :follows_done
      t.integer :votes_received
      t.integer :comments_received
      t.integer :follows_received
      t.float :score
      t.timestamps
    end

    add_reference :decidim_govbr_user_proposals_statistics, :decidim_govbr_user_proposals_statistic_settings, index: { name: :user_proposals_statistics_on_settings_idx }
    add_index :decidim_govbr_user_proposals_statistics, :decidim_user_id, name: :decidim_govbr_user_proposals_statistic_user_idx
  end
end
