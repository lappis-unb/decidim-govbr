class AddAssociatedStateToDecidimMeetingsMeetings < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_meetings_meetings, :associated_state, :integer, default: 0
  end
end
