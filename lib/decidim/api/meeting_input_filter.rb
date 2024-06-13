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
  end
end
