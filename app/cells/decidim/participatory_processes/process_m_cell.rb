# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    # This cell renders the Medium (:m) process card
    # for an given instance of a Process
    class ProcessMCell < Decidim::CardMCell
      include Decidim::SanitizeHelper
      include Decidim::TranslationsHelper
      include Decidim::TwitterSearchHelper

      private

      def description
        text = translated_attribute(model.description)
        strip_tags(text).truncate(100, separator: /\s/)
      end

      def has_image?
        true
      end

      def has_state?
        model.past?
      end

      def has_badge?
        true
      end

      def has_developer_group?
        translated_attribute(model.developer_group).present?
      end

      def badge_name
        state
      end

      def state
        return t("decidim.participatory_processes.card.status.finished") if model.past? && model.active_step&.active == false

        return t("decidim.participatory_processes.card.status.closed") if model.past?

        t("decidim.participatory_processes.card.status.active")
      end

      def has_step?
        model.active_step.present?
      end

      def state_classes
        return ["green"] if model.past? && model.active_step&.active == false

        return ["red"] if model.past?

        ["blue"]
      end

      def resource_path
        Decidim::ParticipatoryProcesses::Engine.routes.url_helpers.participatory_process_path(model)
      end

      def resource_image_path
        model.attached_uploader(:hero_image).path
      end

      def step_cta_text
        if translated_in_current_locale?(model.active_step&.cta_text)
          translated_attribute(model.active_step.cta_text)
        else
          t(model.cta_button_text_key_accessible, resource_name: title, scope: "layouts.decidim.participatory_processes.participatory_process")
        end
      end

      def step_cta_path
        if model.active_step&.cta_path.present?
          path, params = resource_path.split("?")

          "#{path}/#{model.active_step.cta_path}" + (params.present? ? "?#{params}" : "")
        else
          resource_path
        end
      end

      def step_title
        translated_attribute model.active_step.title
      end

      def base_card_class
        "card--component"
      end

      def card_classes
        classes = [base_card_class]
        classes.concat(state_classes).join(" ")
      end

      def statuses
        [:creation_date, :follow]
      end

      def resource_icon
        icon "processes", class: "icon--big"
      end

      def start_date
        model.start_date
      end

      def end_date
        model.end_date
      end
    end
  end
end
