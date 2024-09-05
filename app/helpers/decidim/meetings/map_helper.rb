# frozen_string_literal: true

module Decidim
  module Meetings
    # This helper includes some methods for rendering meetings dynamic maps.
    module MapHelper
      include Decidim::SanitizeHelper

      # Serialize a collection of geocoded meetings to be used by the dynamic map component
      #
      # meetings - A collection of meetings
      def meetings_data_for_map(meetings)
        geocoded_meetings = meetings.select(&:geocoded_and_valid?)
        geocoded_meetings.map do |meeting|
          start_time = meeting.start_time
          end_time = meeting.end_time

          formatted_start_time = start_time ? l(start_time, format: "%H:%M") : "N/A"
          formatted_end_time = end_time ? l(end_time, format: "%H:%M") : "N/A"
          start_time_string = "#{formatted_start_time} - #{formatted_end_time}"

          meeting.slice(:latitude, :longitude, :address).merge(
            title: translated_attribute(meeting.title),
            description: html_truncate(translated_attribute(meeting.description), length: 200),
            startTimeDay: start_time ? l(start_time, format: "%d") : "N/A",
            startTimeMonth: start_time ? l(start_time, format: "%B") : "N/A",
            startTimeYear: start_time ? l(start_time, format: "%Y") : "N/A",
            startTime: start_time_string,
            icon: icon("meetings", width: 40, height: 70, remove_icon_class: true),
            location: translated_attribute(meeting.location),
            locationHints: decidim_html_escape(translated_attribute(meeting.location_hints)),
            link: resource_locator(meeting).path
          )
        end
      end
    end
  end
end
