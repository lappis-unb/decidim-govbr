# frozen_string_literal: true

module Decidim
  module Surveys
    # Exposes the survey resource so users can view and answer them.
    class SurveysController < Decidim::Surveys::ApplicationController
      include Decidim::Forms::Concerns::HasQuestionnaire
      include Decidim::ComponentPathHelper
      helper Decidim::Surveys::SurveyHelper
      include Decidim::Govbr::ParticipatoryProcessesHelper

      delegate :allow_unregistered?, to: :current_settings

      before_action :check_permissions

      before_action :update_user_poll_answered, only: [:answer], if: -> { should_update_user_poll_answered }
      before_action :should_have_user_full_profile, only: [:show]
      before_action :add_new_question_to_survey, only: [:show]

      def check_permissions
        render :no_permission unless action_authorized_to(:answer, resource: survey).ok?
      end

      def questionnaire_for
        survey
      end

      protected

      def allow_answers?
        !current_component.published? || (current_settings.allow_answers? && survey.open?)
      end

      def form_path
        main_component_path(current_component)
      end

      private

      def i18n_flashes_scope
        "decidim.surveys.surveys"
      end

      def survey
        @survey ||= Survey.find_by(component: current_component)
      end

      def update_user_poll_answered
        return unless current_user.present?

        current_user.update!(user_profile_poll_answered: true)
      end

      def should_update_user_poll_answered
        (current_organization.user_profile_survey_id == current_component.id) &&
          current_participatory_space.should_have_user_full_profile
      end

      def should_have_user_full_profile
        return unless current_participatory_space.is_a? Decidim::ParticipatoryProcess

        if (current_organization.user_profile_survey_id != current_component.id) &&
           current_participatory_space.should_have_user_full_profile &&
           current_user.present? && !current_user.user_profile_poll_answered
          survey_component_id = current_organization.user_profile_survey_id

          flash[:alert] = I18n.t("decidim.components.surveys.actions.action_not_allowed")
          flash[:poll_link] = mount_user_profile_survey_url(survey_id: survey_component_id)
        end
      end

      def add_new_question_to_survey
        record_what_happened_survey = current_participatory_space.record_what_happened_survey.presence.to_s.chomp("/")
        if record_what_happened_survey.present? && request.original_url.include?(record_what_happened_survey)
          questionnaire = survey.questionnaire

          return false if questionnaire.blank?

          Decidim::Forms::Questionnaire.add_new_question(
            decidim_questionnaire_id: questionnaire.id, position: questionnaire.questions.count,
            question_type: "short_answer", mandatory: false,title: "origin_meeting_id",
          )
        end
      end
    end
  end
end
