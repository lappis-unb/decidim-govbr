# frozen_string_literal: true

require "rails_helper"
require "decidim/api/test/type_context"
require "decidim/core/test"
require "decidim/core/test/shared_examples/input_filter_examples"

module Decidim
  module Meetings
    autoload :MeetingInputFilter, "decidim/api/meeting_input_filter"

    describe MeetingInputFilter, type: :graphql do
      include_context "with a graphql class type"

      let(:type_class) { Decidim::Meetings::MeetingsType }

      let(:model) { create(:meeting_component) }
      let!(:models) { create_list(:meeting, 3, :published, component: model) }

      before do
        freeze_time
      end

      after do
        travel_back
      end

      context "when filtered by published_at" do
        include_examples "connection has before/since input filter", "meetings", "published"
      end

      context "when date is before the creation date of the proposals" do
        let(:query) do
          %(
            query {
              meetings(filter: { createdAt: "#{2.days.ago.to_date}"}) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds nothing" do
          ids = response["meetings"]["nodes"].map { |node| node["id"] }
          expect(ids).to eq([])
        end
      end

      context "when date is equal to the creation date of the proposals" do
        let(:query) do
          %(
            query {
              meetings(filter: { createdAt: "#{models.first.created_at.to_date}"}) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds the model" do
          ids = response["meetings"]["nodes"].map { |node| node["id"] }
          expect(ids).to match_array(models.map(&:id).map(&:to_s))
        end
      end

      context "when date is after the update date of the proposals" do
        let(:query) do
          %(
            query {
              meetings(filter: { updatedAt: "#{2.days.from_now.to_date}"}) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds nothing" do
          ids = response["meetings"]["nodes"].map { |node| node["id"] }
          expect(ids).to eq([])
        end
      end

      context "when date is equal to the update date of the proposals" do
        let(:query) do
          %(
            query {
              meetings(filter: { updatedAt: "#{models.first.updated_at.to_date}"}) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds the model" do
          ids = response["meetings"]["nodes"].map { |node| node["id"] }
          expect(ids).to match_array(models.map(&:id).map(&:to_s))
        end
      end
    end
  end
end
