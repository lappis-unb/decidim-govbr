# frozen_string_literal: true

require "rails_helper"
require "decidim/api/test/type_context"
require "decidim/core/test"
require "decidim/core/test/shared_examples/input_filter_examples"

module Decidim
  module Surveys
    autoload :SurveyInputFilter, "decidim/api/survey_input_filter"

    describe SurveyInputFilter, type: :graphql do
      include_context "with a graphql class type"
      let(:type_class) { Decidim::Surveys::SurveysType }

      let(:model) { create(:surveys_component) }
      let!(:models) { create_list(:survey, 3, component: model) }

      context "when date is before the creation date of the proposals" do
        let(:query) do
          %(
            query {
              surveys(filter: { createdAt: "#{2.days.ago.to_date}"}) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds nothing" do
          ids = response["surveys"]["nodes"].map { |node| node["id"] }
          expect(ids).to eq([])
        end
      end

      context "when date is equal to the creation date of the proposals" do
        let(:query) do
          %(
            query {
              surveys(filter: { createdAt: "#{models.first.created_at.to_date}"}) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds the model" do
          ids = response["surveys"]["nodes"].map { |node| node["id"] }
          expect(ids).to match_array(models.map(&:id).map(&:to_s))
        end
      end

      context "when date is after the update date of the proposals" do
        let(:query) do
          %(
            query {
              surveys(filter: { updatedAt: "#{2.days.from_now.to_date}"}) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds nothing" do
          ids = response["surveys"]["nodes"].map { |node| node["id"] }
          expect(ids).to eq([])
        end
      end

      context "when date is equal to the update date of the proposals" do
        let(:query) do
          %(
            query {
              surveys(filter: { updatedAt: "#{models.first.updated_at.to_date}"}) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds the model" do
          ids = response["surveys"]["nodes"].map { |node| node["id"] }
          expect(ids).to match_array(models.map(&:id).map(&:to_s))
        end
      end
    end
  end
end
