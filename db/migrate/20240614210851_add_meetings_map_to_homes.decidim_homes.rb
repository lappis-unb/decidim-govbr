# frozen_string_literal: true
# This migration comes from decidim_homes

class AddMeetingsMapToHomes < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_homes_homes, :meetings_map, :boolean, default: false
  end
end
