# frozen_string_literal: true

module Decidim
  module Comments
    # A helper to expose the comments component for a commentable
    module CommentsHelper
      # Render commentable comments inside the `expanded` template content.
      #
      # resource - A commentable resource
      def comments_for(resource, options = {})
        return unless resource.commentable?

        content_for :expanded do
          inline_comments_for(resource, options)
        end
      end

      # Creates a Comments component through the comments cell.
      #
      # resource - A commentable resource
      #
      # Returns the comments cell
      def inline_comments_for(resource, options = {})
        return unless resource.commentable?

        if options.try(:[], :hide_comment_action)
          cell(
            "decidim/comments/comments",
            resource,
            machine_translations: machine_translations_toggled?,
            single_comment: params.fetch("commentId", nil),
            order: options[:order],
            polymorphic: options[:polymorphic],
            hide_comment_action: options[:hide_comment_action],
            alert: options[:alert],
            poll_link: options[:poll_link]
          ).to_s
        else
          cell(
            "decidim/comments/comments",
            resource,
            machine_translations: machine_translations_toggled?,
            single_comment: params.fetch("commentId", nil),
            order: options[:order],
            polymorphic: options[:polymorphic]
          ).to_s
        end
      end
    end
  end
end
