# frozen_string_literal: true
# This migration comes from decidim_homes (originally 20020711110602)

class RenameFeaturesToComponentsAtHomes < ActiveRecord::Migration[5.1]
  def change
    rename_column :decidim_homes_homes, :decidim_feature_id, :decidim_component_id

    if index_name_exists?(:decidim_homes_homes, "index_decidim_homes_homes_on_decidim_feature_id")
      rename_index :decidim_homes_homes, "index_decidim_homes_homes_on_decidim_feature_id", "index_decidim_homes_homes_on_decidim_component_id"
    end
  end
end
