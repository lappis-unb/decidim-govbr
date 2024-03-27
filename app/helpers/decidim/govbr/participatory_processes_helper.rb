module Decidim
  module Govbr
    module ParticipatoryProcessesHelper
      def user_survey_answered?
        current_user.present? && current_user.user_profile_poll_answered
      end

      def user_full_profile_required?
        current_user.present? && current_participatory_space.should_have_user_full_profile
      end
    end
  end
end