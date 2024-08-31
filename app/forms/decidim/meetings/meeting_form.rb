# frozen_string_literal: true

module Decidim
  module Meetings
    # This class holds a Form to create/update meetings for Participants and UserGroups.
    class MeetingForm < ::Decidim::Meetings::BaseMeetingForm
      include Decidim::AttachmentAttributes

      # Atributos e validações
      ATTRIBUTES = [
        :title, :description, :location, :location_hints, :attachment,
        :decidim_scope_id, :decidim_category_id, :user_group_id,
        :registration_type, :registrations_enabled, :registration_url,
        :available_slots, :registration_terms, :iframe_embed_type,
        :iframe_access_level, :photos, :documents
      ].freeze

      attribute :title, String
      attribute :description, String
      attribute :location, String
      attribute :location_hints, String
      attribute :attachment, AttachmentForm

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
      attachments_attribute :photos
      attachments_attribute :documents

      validates :iframe_embed_type, inclusion: { in: Decidim::Meetings::Meeting.participants_iframe_embed_types }
      validates :title, :description, :type_of_meeting, presence: true
      validates :location, presence: true, if: -> { in_person_meeting? || hybrid_meeting? }
      validates :online_meeting_url, presence: true, url: true, if: -> { online_meeting? || hybrid_meeting? }
      validates :registration_type, presence: true
      validates :available_slots, numericality: { greater_than_or_equal_to: 0 }, presence: true, if: -> { on_this_platform? }
      validates :registration_terms, presence: true, if: -> { on_this_platform? }
      validates :registration_url, presence: true, url: true, if: -> { on_different_platform? }
      validates :category, presence: true, if: -> { decidim_category_id.present? }
      validates :scope, presence: true, if: -> { decidim_scope_id.present? }
      validates :decidim_scope_id, scope_belongs_to_component: true, if: -> { decidim_scope_id.present? }
      validates :clean_type_of_meeting, presence: true
      validates :iframe_access_level, inclusion: { in: Decidim::Meetings::Meeting.iframe_access_levels }, if: -> { %w(embed_in_meeting_page open_in_new_tab).include?(iframe_embed_type) }
      validate :embeddable_meeting_url

      delegate :categories, to: :current_component

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

      def scope
        @scope ||= find_scope
      end

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

      # Métodos de Seleção
      def type_of_meeting_select
        select_options(Decidim::Meetings::Meeting::TYPE_OF_MEETING, "type_of_meeting")
      end

      def iframe_access_level_select
        select_options(Decidim::Meetings::Meeting.iframe_access_levels.keys, "iframe_access_level")
      end

      def iframe_embed_type_select
        select_options(Decidim::Meetings::Meeting.participants_iframe_embed_types.keys, "iframe_embed_type")
      end

      def registration_type_select
        select_options(Decidim::Meetings::Meeting::REGISTRATION_TYPE, "registration_type")
      end

      # Métodos de Verificação
      def on_this_platform?
        registration_type == "on_this_platform"
      end

      def on_different_platform?
        registration_type == "on_different_platform"
      end

      def registrations_enabled
        on_this_platform?
      end

      # Método de URL Embutível
      def embeddable_meeting_url
        return unless online_meeting_url.present? && %w(embed_in_meeting_page open_in_live_event_page).include?(iframe_embed_type)

        embedder_service = Decidim::Meetings::MeetingIframeEmbedder.new(online_meeting_url)
        errors.add(:iframe_embed_type, :not_embeddable) unless embedder_service.embeddable?
      end

      private

      def select_options(options, scope)
        options.map do |option|
          [
            I18n.t("#{scope}.#{option}", scope: "decidim.meetings"),
            option
          ]
        end
      end

      def find_scope
        if @attributes["decidim_scope_id"].value
          current_component.scopes.find_by(id: @attributes["decidim_scope_id"].value)
        else
          current_component.scope
        end
      end
    end
  end
end
