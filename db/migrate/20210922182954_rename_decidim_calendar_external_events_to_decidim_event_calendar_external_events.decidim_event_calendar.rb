# frozen_string_literal: true
# This migration comes from decidim_event_calendar (originally 20210921223545)

class RenameDecidimCalendarExternalEventsToDecidimEventCalendarExternalEvents < ActiveRecord::Migration[5.2]
  def change
    rename_table :decidim_calendar_external_events, :decidim_event_calendar_external_events
  end
end
