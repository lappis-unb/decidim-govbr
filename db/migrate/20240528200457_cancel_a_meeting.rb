class CancelAMeeting < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_meetings_meetings, :cancelled, :boolean, default: false, null: false
  end
end
