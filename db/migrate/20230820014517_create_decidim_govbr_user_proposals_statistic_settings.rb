class CreateDecidimGovbrUserProposalsStatisticSettings < ActiveRecord::Migration[6.1]
  def up
    create_table :decidim_govbr_user_proposals_statistic_settings do |t|
      t.string :name, null: false, default: ''
      t.string :decidim_participatory_space_type, null: false
      t.integer :decidim_participatory_space_id, null: false
      t.float :proposals_done_weight, default: 1.0
      t.float :comments_done_weight, default: 1.0
      t.float :votes_done_weight, default: 1.0
      t.float :follows_done_weight, default: 1.0
      t.float :votes_received_weight, default: 1.0
      t.float :comments_received_weight, default: 1.0
      t.float :follows_received_weight, default: 1.0
      t.integer :users_to_be_exported, default: 200, null: false
      t.timestamps
    end
    add_index :decidim_govbr_user_proposals_statistic_settings, [:decidim_participatory_space_type, :decidim_participatory_space_id], name: :user_proposals_statistic_settings_participatory_space_idx

    Decidim::Govbr::UserProposalsStatisticSetting.create(
      decidim_participatory_space_id: Decidim::Assembly.find_by(slug: 'confjuv4').id,
      decidim_participatory_space_type: 'Decidim::Assembly',
      name: 'Relatorio Atividade em Propostas - IV Conferência Nacional Da Juventude'
    ) rescue false
  end

  def down
    remove_index :decidim_govbr_user_proposals_statistic_settings, [:decidim_participatory_space_type, :decidim_participatory_space_id], name: :user_proposals_statistic_settings_participatory_space_idx
    drop_table :decidim_govbr_user_proposals_statistic_settings
  end
end
