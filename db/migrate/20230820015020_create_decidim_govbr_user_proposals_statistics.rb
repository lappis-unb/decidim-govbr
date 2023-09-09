class CreateDecidimGovbrUserProposalsStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_govbr_user_proposals_statistics do |t|
      t.bigint :decidim_user_id, null: false
      t.string :decidim_user_identification_number, null: false, default: ''
      t.string :decidim_user_name
      t.integer :proposals_done, default: 0
      t.integer :comments_done, default: 0
      t.integer :votes_done, default: 0
      t.integer :follows_done, default: 0
      t.integer :votes_received, default: 0
      t.integer :comments_received, default: 0
      t.integer :follows_received, default: 0
      t.float :score, default: 0.0
      t.timestamps
    end

    add_reference :decidim_govbr_user_proposals_statistics, :user_proposals_statistic_setting, index: { name: :user_proposals_statistics_on_settings_idx }
    add_index :decidim_govbr_user_proposals_statistics, :decidim_user_id, name: :decidim_govbr_user_proposals_statistic_user_idx
  end
end
