# frozen_string_literal: true

module Decidim
  module Surveys
    class SurveyInputFilter < Decidim::Core::BaseInputFilter
      include Decidim::Core::HasPublishableInputFilter

      graphql_name "SurveyFilter"
      description "A type used for filtering surveys inside a participatory space.

A typical query would look like:

```
  {
    participatoryProcesses {
      components {
        ...on Surveys {
          surveys(filter:{ publishedBefore: \"2020-01-01\" }) {
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
