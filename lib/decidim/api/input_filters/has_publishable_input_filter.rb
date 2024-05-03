# frozen_string_literal: true

module Decidim
  module Core
    module HasPublishableInputFilter
      def self.included(child_class)
        child_class.argument :published_before,
                             type: GraphQL::Types::String,
                             description: "List result published **before** (and **excluding**) this date. Expected format `YYYY-MM-DD`",
                             required: false,
                             prepare: lambda { |date, _ctx|
                               proc do |model_class|
                                 model_class.arel_table[:published_at].lt(date_to_iso8601(date, :publishedBefore))
                               end
                             }
        child_class.argument :published_since,
                             type: GraphQL::Types::String,
                             description: "List result published after (and **including**) this date. Expected format `YYYY-MM-DD`",
                             required: false,
                             prepare: lambda { |date, _ctx|
                               proc do |model_class|
                                 model_class.arel_table[:published_at].gteq(date_to_iso8601(date, :published_since))
                               end
                             }
        child_class.argument :created_at,
                             type: GraphQL::Types::String,
                             description: "List result created at this exact date. Expected format `YYYY-MM-DD`",
                             required: false,
                             prepare: lambda { |date, _ctx|
                               proc do |model_class|
                                 start_of_day = Date.parse(date)
                                 end_of_day = start_of_day + 1.day

                                 model_class.arel_table[:created_at].gteq(start_of_day).and(
                                   model_class.arel_table[:created_at].lt(end_of_day)
                                 )
                               end
                             }

        child_class.argument :updated_at,
                             type: GraphQL::Types::String,
                             description: "List result updated at this exact date. Expected format `YYYY-MM-DD`",
                             required: false,
                             prepare: lambda { |date, _ctx|
                               proc do |model_class|
                                 start_of_day = Date.parse(date)
                                 end_of_day = start_of_day + 1.day

                                 model_class.arel_table[:updated_at].gteq(start_of_day).and(
                                   model_class.arel_table[:updated_at].lt(end_of_day)
                                 )
                               end
                             }

        child_class.argument :id,
                             type: GraphQL::Types::ID,
                             description: "List result with this id",
                             required: false,
                             prepare: lambda { |id, _ctx|
                                        proc do |model_class|
                                          model_class.arel_table[:id].eq(id)
                                        end
                                      }
      end

      def self.date_to_iso8601(date, key)
        Date.iso8601(date)
      rescue StandardError
        raise GraphQL::ExecutionError, "Invalid date format for #{key}"
      end
    end
  end
end
