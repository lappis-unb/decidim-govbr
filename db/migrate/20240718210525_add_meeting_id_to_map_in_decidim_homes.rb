class AddMeetingIdToMapInDecidimHomes < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_homes_homes, :meeting_id, :integer
  end
end
