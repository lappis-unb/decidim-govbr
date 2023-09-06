class CreateDecidimGovbrUserProposalsStatistics < ActiveRecord::Migration[6.1]
  def change
    # TODO: adicionar default de 0 nos fields
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

    begin
      statistic_setting = Decidim::Govbr::UserProposalsStatisticSetting.find_by(decidim_participatory_space_id: Decidim::ParticipatoryProcess.find_by(slug: 'engd').id)
      unless statistic_setting.present?
        Decidim::Govbr::UserProposalsStatisticSetting.create(
          decidim_participatory_space_id: Decidim::ParticipatoryProcess.find_by(slug: 'engd').id,
          decidim_participatory_space_type: 'Decidim::ParticipatoryProcess',
          name: 'Relatorio de atividade Usuario x Propostas - ENGD'
        )
      end
    rescue
      # Ensure migration runs regardless of this task
    end
  end
end
