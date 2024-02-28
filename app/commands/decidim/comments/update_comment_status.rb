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
        update_comment_status

        broadcast(:ok)
      end

      private

      attr_reader :params, :comment, :current_user

      def update_comment_status
        @comment = comment.update(status: params[:comment][:status])
      end
    end
  end
end
