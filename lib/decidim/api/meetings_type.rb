# frozen_string_literal: true

module Decidim
  module Meetings
    class MeetingInputFilter < Decidim::Core::BaseInputFilter
      include Decidim::Core::HasPublishableInputFilter

      graphql_name "MeetingFilter"
      description "A type used for filtering meetings inside a participatory space.

A typical query would look like:

```
  {
    participatoryProcesses {
      components {
        ...on Meetings {
          meetings(filter:{ publishedBefore: \"2020-01-01\" }) {
            id
          }
        }
      }
    }
  }
```
"
    end

    class MeetingListHelper < Decidim::Core::ComponentListBase
      # only querying published posts
      def query_scope
        super.published
      end
    end

    class MeetingFinderHelper < Decidim::Core::ComponentFinderBase
      # only querying published posts
      def query_scope
        super.published
      end
    end

    class MeetingsType < Decidim::Api::Types::BaseObject
      implements Decidim::Core::ComponentInterface

      graphql_name "Meetings"
      description "A meetings component of a participatory space."

      field :meetings, Decidim::Meetings::MeetingType.connection_type, description: "List all meetings", null: true, connection: true do
        argument :filter, Decidim::Meetings::MeetingInputFilter, "Provides several methods to filter the results", required: false
      end

      field :meeting, Decidim::Meetings::MeetingType, null: true do
        argument :id, GraphQL::Types::ID, required: true
      end

      def meetings(filter: {})
        Decidim::Meetings::MeetingListHelper.new(model_class: Meeting).call(object, { filter: filter }, context)
      end

      def meeting(**args)
        Meeting.published.visible.where(component: object).find_by(id: args[:id])
      end
    end
  end
end
