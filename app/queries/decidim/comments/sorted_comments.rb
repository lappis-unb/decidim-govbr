# frozen_string_literal: true

module Decidim
  module Comments
    # A class used to find comments for a commentable resource
    class SortedComments < Decidim::Query
      attr_reader :commentable

      # Syntactic sugar to initialize the class and return the queried objects.
      #
      # commentable - a resource that can have comments
      # options - The Hash options is used to refine the selection ( default: {}):
      #           :order_by - The string order_by to sort by ( optional )
      def self.for(commentable, options = {})
        new(commentable, options).query
      end

      # Initializes the class.
      #
      # commentable = a resource that can have comments
      # options - The Hash options is used to refine the selection ( default: {}):
      #           :order_by - The string order_by to sort by ( optional )
      def initialize(commentable, options = {})
        options[:order_by] ||= "recent"
        @commentable = commentable
        @options = options
      end

      # Finds the Comments for a resource that can have comments and eager
      # loads comments replies. It uses Comment's MAX_DEPTH to load a maximum
      # level of nested replies.
      def query
        scope = base_scope
                .includes(:author, :user_group)

        case @options[:order_by]
        when "recent"
          order_by_recent(scope)
        else
          order_by_older(scope)
        end
      end

      private

      def base_scope
        id = @options[:id]
        return Comment.where(root_commentable: commentable, id: id) if id.present?

        after = @options[:after]
        if after.present?
          return Comment.where(root_commentable: commentable).where(
            "decidim_comments_comments.id > ?",
            after
          )
        end

        Comment.where(commentable: commentable)
      end

      def order_by_older(scope)
        scope.order(created_at: :asc)
      end

      def order_by_recent(scope)
        scope.order(created_at: :desc)
      end

      def order_by_most_discussed(scope)
        scope.sort_by do |comment|
          count_replies(comment)
        end.reverse
      end

      def count_replies(comment)
        if comment.comment_threads.size.positive?
          comment.comment_threads.size + comment.comment_threads.sum { |reply| count_replies(reply) }
        else
          0
        end
      end
    end
  end
end
