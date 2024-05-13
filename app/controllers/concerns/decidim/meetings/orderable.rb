# frozen_string_literal: true
require "active_support/concern"

module Decidim
  module Meetings
    # Common logic to ordering resources
    module Orderable
      extend ActiveSupport::Concern

      included do
        include Decidim::Orderable

        private

        # Available orders based on enabled settings
        def available_orders
          @available_orders ||= %w(
            most_commented
            most_followed
            recent
            random
          )
        end

        def reorder(meetings)
          case order
          when "most_commented"
            meetings.order(comments_count: :desc)
          when "most_followed"
            meetings.left_joins(:registrations)
                    .select("decidim_meetings_meetings.*, COUNT(decidim_meetings_registrations.id) AS registrations_count")
                    .group(:id)
                    .order("registrations_count DESC")
          when "recent"
            meetings.order(published_at: :desc)
          when "random"
            meetings.order_randomly(random_seed)
          end
        end
      end
    end
  end
end
