# frozen_string_literal: true
# This migration comes from decidim_homes (originally 20020711110601)

class CreateDecidimHomes < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_homes_homes do |t|
      t.jsonb :title
      t.references :decidim_feature, index: true
      t.string :banner
      t.string :digital_stage, default: '/'
      t.string :organize_stage, default: '/'
      t.string :schedule, default: '/'
      t.string :common_questions, default: '/'
      t.string :support_material, default: '/'
      t.boolean :statistics, default: false
      t.boolean :news, default: false
      t.integer :news_id
      t.jsonb :organizers, default: []
      t.jsonb :supporters, default: []

      t.timestamps
    end
  end
end

