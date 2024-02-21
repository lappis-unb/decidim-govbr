# frozen_string_literal: true

class CreateMediaLink < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_govbr_media_links do |t|
      t.string :participatory_space_type
      t.bigint :participatory_space_id
      t.jsonb :title, null: false
      t.string :link, null: false
      t.date :date
      t.integer :weight, null: false, default: 0

      t.timestamps
    end

    add_index :decidim_govbr_media_links, [:participatory_space_type, :participatory_space_id], name: :decidim_govbr_media_links_ps_index
  end
end
