class CreatePartner < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_govbr_partners do |t|
      t.string :partnerable_type
      t.bigint :partnerable_id
      t.string :name, null: false
      t.string :partner_type, null: false
      t.integer :weight, default: 0, null: false
      t.string :link
      t.string :logo

      t.timestamps
    end

    add_index :decidim_govbr_partners, [:partnerable_type, :partnerable_id], name: :partner_partnerable_index
  end
end
