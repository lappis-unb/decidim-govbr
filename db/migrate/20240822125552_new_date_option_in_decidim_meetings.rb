class NewDateOptionInDecidimMeetings < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_meetings_meetings, :to_define, :boolean, default: false
  end
end
