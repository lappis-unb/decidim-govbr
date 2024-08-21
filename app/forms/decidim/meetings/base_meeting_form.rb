# frozen_string_literal: true

module Decidim
  module Meetings
    class BaseMeetingForm < Decidim::Form
      attribute :address, String
      attribute :latitude, Float
      attribute :longitude, Float
      attribute :online_meeting_url, String
      attribute :type_of_meeting, String
      attribute :start_time, Decidim::Attributes::TimeWithZone
      attribute :end_time, Decidim::Attributes::TimeWithZone
      attribute :associated_state, String

      validates :associated_state, presence: true

      validates :current_component, presence: true

      validates :address, presence: true, if: ->(form) { form.needs_address? }
      validates :address, geocoding: true, if: ->(form) { form.has_address? && !form.geocoded? && form.needs_address? }
      validates :start_time, presence: true, date: { before: :end_time }
      validates :end_time, presence: true, date: { after: :start_time }

      def type_of_meeting_select
        Decidim::Meetings::Meeting::TYPE_OF_MEETING.map do |type|
          [
            I18n.t("type_of_meeting.#{type}", scope: "decidim.meetings"),
            type
          ]
        end
      end

      def geocoding_enabled?
        Decidim::Map.available?(:geocoding)
      end

      def geocoded?
        latitude.present? && longitude.present?
      end

      def has_address?
        geocoding_enabled? && address.present?
      end

      def needs_address?
        in_person_meeting? || hybrid_meeting?
      end

      def online_meeting?
        type_of_meeting == "online"
      end

      def in_person_meeting?
        type_of_meeting == "in_person"
      end

      def hybrid_meeting?
        type_of_meeting == "hybrid"
      end

      def meeting_state_select
        Decidim::Meetings::Meeting.associated_states.keys.map do |associated_state|
          [
            I18n.t("associated_states.#{associated_state}", scope: "decidim.meetings"),
            associated_state
          ]
        end
      end

      def iframe_access_level_select
        Decidim::Meetings::Meeting.iframe_access_levels.map do |level, _value|
          [
            I18n.t("iframe_access_level.#{level}", scope: "decidim.meetings"),
            level
          ]
        end
      end

      def iframe_embed_type_select
        Decidim::Meetings::Meeting.iframe_embed_types.map do |type, _value|
          [
            I18n.t("iframe_embed_type.#{type}", scope: "decidim.meetings"),
            type
          ]
        end
      end
    end
  end
end
