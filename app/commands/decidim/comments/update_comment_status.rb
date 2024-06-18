# frozen_string_literal: true

module Decidim
  module Comments
    # A command with all the business logic to update an existing comment
    class UpdateCommentStatus < Decidim::Command
      # Public: Initializes the command.
      #
      # comment - Decidim::Comments::Comment
      # current_user - Decidim::User
      # params - A params object with the params.
      def initialize(comment, current_user, params)
        @comment = comment
        @current_user = current_user
        @params = params
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the params wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) unless user_can_update_comment_status?

        update_comment_status

        broadcast(:ok)
      end

      private

      attr_reader :params, :comment, :current_user

      def user_can_update_comment_status?
        current_user.admin? unless current_participatory_space.is_a?(ParticipatoryProcess)

        Decidim::ParticipatoryProcessesWithUserRole.for(current_user, [:admin, :moderator]).include?(current_participatory_space) || current_user.admin?
      end

      def current_participatory_space
        comment.component.participatory_space
      end

      def update_comment_status
        @comment = comment.update(status: params[:comment][:status])
      end
    end
  end
end
