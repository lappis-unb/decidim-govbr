# frozen_string_literal: true

module Decidim
  module Meetings
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user

        # Delegate the admin permission checks to the admin permissions class
        return Decidim::Meetings::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin
        return permission_action if permission_action.scope != :public

        case permission_action.subject
        when :answer
          case permission_action.action
          when :create
            toggle_allow(can_answer_question?)
          end
        when :question
          case permission_action.action
          when :update
            toggle_allow(can_update_question?)
          end
        when :meeting
          case permission_action.action
          when :join
            toggle_allow(can_join_meeting?)
          when :leave
            toggle_allow(can_leave_meeting?)
          when :decline_invitation
            toggle_allow(can_decline_invitation?)
          when :create
            toggle_allow(can_create_meetings?)
          when :update
            toggle_allow(can_update_meeting?)
          when :cancel
            toggle_allow(can_cancel_meeting?)
          when :withdraw
            toggle_allow(can_withdraw_meeting?)
          when :destroy
            toggle_allow(can_destroy_meeting?)
          when :close
            toggle_allow(can_close_meeting?)
          when :register
            toggle_allow(can_register_invitation_meeting?)
          when :register_what_happened
            toggle_allow(can_register_what_happened_meeting?)
          when :export_registrations
            toggle_allow(can_export_registrations?)
          end
        else
          return permission_action
        end

        permission_action
      end

      private

      def meeting
        @meeting ||= context.fetch(:meeting, nil)
      end

      def question
        @question ||= context.fetch(:question, nil)
      end

      def can_join_meeting?
        meeting.can_be_joined_by?(user) &&
          authorized?(:join, resource: meeting)
      end

      def can_leave_meeting?
        meeting.registrations_enabled?
      end

      def can_decline_invitation?
        meeting.registrations_enabled? &&
          meeting.invites.exists?(user: user)
      end

      def can_create_meetings?
        component_settings&.creation_enabled_for_participants?
      end

      def can_update_meeting?
        component_settings&.creation_enabled_for_participants? &&
          meeting.authored_by?(user) &&
          !meeting.closed? &&
          !meeting.finished?
      end

      def can_cancel_meeting?
        component_settings&.creation_enabled_for_participants? &&
          meeting.authored_by?(user) &&
          !meeting.closed? &&
          !meeting.cancelled? &&
          !meeting.finished? &&
          !meeting.running?
      end

      def can_withdraw_meeting?
        component_settings&.creation_enabled_for_participants? &&
          meeting.authored_by?(user) &&
          !meeting.withdrawn? &&
          meeting.subscribers_count.zero? &&
          !meeting.closed? &&
          !meeting.finished?
      end

      def can_close_meeting?
        component_settings&.creation_enabled_for_participants? &&
          meeting.authored_by?(user) &&
          meeting.past? &&
          meeting.finished? &&
          !meeting.closed? &&
          !meeting.withdrawn?
      end

      def can_register_invitation_meeting?
        meeting.can_register_invitation?(user) &&
          authorized?(:register, resource: meeting)
      end

      def can_register_what_happened_meeting?
        meeting.authored_by?(user) &&
          meeting.finished?
      end

      def can_destroy_meeting?
        meeting.authored_by?(user) &&
          user.admin?
      end

      def can_export_registrations?
        meeting.present? && user.present? && (user.admin? || meeting.authored_by?(user))
      end

      def can_answer_question?
        question.present? && user.present? && !question.answered_by?(user)
      end

      def can_update_question?
        user.present? && user.admin? && question.present?
      end
    end
  end
end
