module Decidim
  module Govbr
    module ParticipatoryProcessesHelper
      def user_survey_answered?
        current_user.present? && current_user.user_profile_poll_answered
      end

      def user_full_profile_required?
        current_user.present? && current_participatory_space.try(:should_have_user_full_profile)
      end

      def mount_user_profile_survey_url(survey_id:)
        participatory_space_id = Decidim::Component.find(survey_id).try(:[], :participatory_space_id)
        participatory_process = Decidim::ParticipatoryProcess.find(participatory_space_id) if participatory_space_id.present?

        if participatory_process.present?
          "/processes/#{participatory_process.slug}/f/#{survey_id}"
        else
          "#"
        end
      end
    end
  end
end