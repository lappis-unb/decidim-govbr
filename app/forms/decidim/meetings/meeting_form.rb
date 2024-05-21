# frozen_string_literal: true

module Decidim
  module Meetings
    # This class holds a Form to create/update meetings for Participants and UserGroups.
    class MeetingForm < ::Decidim::Meetings::BaseMeetingForm
      attribute :title, String
      attribute :description, String
      attribute :location, String
      attribute :location_hints, String

      attribute :decidim_scope_id, Integer
      attribute :decidim_category_id, Integer
      attribute :user_group_id, Integer
      attribute :registration_type, String
      attribute :registrations_enabled, Boolean, default: false
      attribute :registration_url, String
      attribute :available_slots, Integer, default: 0
      attribute :registration_terms, String
      attribute :iframe_embed_type, String, default: "none"
      attribute :iframe_access_level, String

      attribute :start_date, String
      attribute :start_time_only, String
      attribute :end_date, String
      attribute :end_time_only, String

      validates :iframe_embed_type, inclusion: { in: Decidim::Meetings::Meeting.participants_iframe_embed_types }
      validates :title, presence: true, length: { in: 15..150 }

      
      validates :description, presence: true
      validates :type_of_meeting, presence: true
      validates :location, presence: true, if: ->(form) { form.in_person_meeting? || form.hybrid_meeting? }
      validates :online_meeting_url, presence: true, url: true, if: ->(form) { form.online_meeting? || form.hybrid_meeting? }
      validates :registration_type, presence: true
      validates :available_slots, numericality: { greater_than_or_equal_to: 0 }, presence: true, if: ->(form) { form.on_this_platform? }
      validates :registration_terms, presence: true, if: ->(form) { form.on_this_platform? }
      validates :registration_url, presence: true, url: true, if: ->(form) { form.on_different_platform? }
      validates :category, presence: true, if: ->(form) { form.decidim_category_id.present? }
      validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }
      validates :decidim_scope_id, scope_belongs_to_component: true, if: ->(form) { form.decidim_scope_id.present? }
      validates :clean_type_of_meeting, presence: true
      validates(
        :iframe_access_level,
        inclusion: { in: Decidim::Meetings::Meeting.iframe_access_levels },
        if: ->(form) { %w(embed_in_meeting_page open_in_new_tab).include?(form.iframe_embed_type) }
      )
      validate :embeddable_meeting_url
      validate :start_must_be_before_end

      delegate :categories, to: :current_component

      def valid?(context = nil)
        combine_datetime_fields
        super(context)
      end

      def map_model(model)
        self.decidim_category_id = model.categorization.decidim_category_id if model.categorization
        presenter = MeetingEditionPresenter.new(model)
        self.title = presenter.title(all_locales: false)
        self.description = presenter.description(all_locales: false)
        self.location = presenter.location(all_locales: false)
        self.location_hints = presenter.location_hints(all_locales: false)
        self.registration_terms = presenter.registration_terms(all_locales: false)
        self.type_of_meeting = model.type_of_meeting
      end

      alias component current_component

      # Finds the Scope from the given decidim_scope_id, uses the compoenent scope if missing.
      #
      # Returns a Decidim::Scope
      def scope
        @scope ||= @attributes["decidim_scope_id"].value ? current_component.scopes.find_by(id: @attributes["decidim_scope_id"].value) : current_component.scope
      end

      # Scope identifier
      #
      # Returns the scope identifier related to the meeting
      def decidim_scope_id
        super || scope&.id
      end

      def category
        return unless current_component

        @category ||= categories.find_by(id: decidim_category_id)
      end

      def clean_type_of_meeting
        type_of_meeting.presence
      end

      def type_of_meeting_select
        Decidim::Meetings::Meeting::TYPE_OF_MEETING.map do |type|
          [
            I18n.t("type_of_meeting.#{type}", scope: "decidim.meetings"),
            type
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
        Decidim::Meetings::Meeting.participants_iframe_embed_types.map do |type, _value|
          [
            I18n.t("iframe_embed_type.#{type}", scope: "decidim.meetings"),
            type
          ]
        end
      end

      def on_this_platform?
        registration_type == "on_this_platform"
      end

      def on_different_platform?
        registration_type == "on_different_platform"
      end

      def registration_type_select
        Decidim::Meetings::Meeting::REGISTRATION_TYPE.map do |type|
          [
            I18n.t("registration_type.#{type}", scope: "decidim.meetings"),
            type
          ]
        end
      end

      def registrations_enabled
        on_this_platform?
      end

      def embeddable_meeting_url
        if online_meeting_url.present? && %w(embed_in_meeting_page open_in_live_event_page).include?(iframe_embed_type)
          embedder_service = Decidim::Meetings::MeetingIframeEmbedder.new(online_meeting_url)
          errors.add(:iframe_embed_type, :not_embeddable) unless embedder_service.embeddable?
        end
      end

      def combine_datetime_fields
        if start_date.present? && start_time_only.present?
          self.start_time = DateTime.parse("#{start_date} #{start_time_only}")
        end

        if end_date.present? && end_time_only.present?
          self.end_time = DateTime.parse("#{end_date} #{end_time_only}")
        end
      end

      def start_must_be_before_end
        if start_date.present? && start_time_only.present? && end_date.present? && end_time_only.present?
          start_datetime = DateTime.parse("#{start_date} #{start_time_only}")
          end_datetime = DateTime.parse("#{end_date} #{end_time_only}")
          if start_datetime >= end_datetime
            errors.add(:start_date, 'must be before end date')
            errors.add(:start_time_only, 'must be before end time')
            errors.add(:end_date, 'must be after start date')
            errors.add(:end_time_only, 'must be after start time')
          end
        end
      end

    end
  end
end
