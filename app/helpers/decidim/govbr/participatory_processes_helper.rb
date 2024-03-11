module Decidim
  module Govbr
    module ParticipatoryProcessesHelper
      def should_allow_user_action?
        current_user.present? && current_user.user_profile_poll_answered
      end
    end
  end
end