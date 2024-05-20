# frozen_string_literal: true

module Decidim
  module Surveys
    class SurveysInputFilter < Decidim::Core::BaseInputFilter
      include Decidim::Core::HasPublishableInputFilter

      graphql_name "SurveysFilter"
      description "A type used for filtering surveys inside a participatory space.

A typical query would look like:

```
  {
    participatoryProcesses {
      components {
        ...on surveys {
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

    class SurveysType < Decidim::Api::Types::BaseObject
      implements Decidim::Core::ComponentInterface

      graphql_name "Surveys"
      description "A surveys component of a participatory space."

      field :surveys, Decidim::Surveys::SurveyType.connection_type, null: true, connection: true, description: "List all surveys" do
        argument :filter, Decidim::Surveys::SurveysInputFilter, "Provides several methods to filter the results", required: false
      end

      field :survey, Decidim::Surveys::SurveyType, null: true do
        argument :id, GraphQL::Types::ID, required: true
      end

      def surveys(filter: {})
        Decidim::Core::ComponentListBase.new(model_class: Survey).call(object, { filter: filter }, context)
      end

      def survey(**args)
        Survey.where(component: object).find_by(id: args[:id])
      end
    end
  end
end
