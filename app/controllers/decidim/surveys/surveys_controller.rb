# frozen_string_literal: true

module Decidim
  module Surveys
    # Exposes the survey resource so users can view and answer them.
    class SurveysController < Decidim::Surveys::ApplicationController
      include Decidim::Forms::Concerns::HasQuestionnaire
      include Decidim::ComponentPathHelper
      helper Decidim::Surveys::SurveyHelper

      delegate :allow_unregistered?, to: :current_settings

      before_action :check_permissions

      before_action :update_user_poll_answered, only: [:answer], if: -> { should_update_user_poll_answered }
      before_action :should_have_user_full_profile, only: [:show]

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
        current_user.update!(user_profile_poll_answered: true)
      end

      def should_update_user_poll_answered
        expected_poll_link = "/processes/#{params[:participatory_process_slug]}/f/#{params[:component_id]}"

        (current_organization.user_profile_poll_link.include? expected_poll_link) &&
          current_participatory_space.should_have_user_full_profile
      end

      def should_have_user_full_profile
        expected_poll_link = "/processes/#{params[:participatory_process_slug]}/f/#{params[:component_id]}"

        if (!current_organization.user_profile_poll_link.include? expected_poll_link) &&
           current_participatory_space.should_have_user_full_profile && !current_user.user_profile_poll_answered
          flash[:alert] = I18n.t("decidim.components.proposals.actions.action_not_allowed")
          flash[:poll_link] = current_organization.user_profile_poll_link.to_s
        end
      end
    end
  end
end
