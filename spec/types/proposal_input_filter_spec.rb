# frozen_string_literal: true

require "rails_helper"
require "decidim/api/test/type_context"
require "decidim/core/test"
require "decidim/core/test/shared_examples/input_filter_examples"

module Decidim
  module Proposals
    describe ProposalInputFilter, type: :graphql do
      include_context "with a graphql class type"
      let(:type_class) { Decidim::Proposals::ProposalsType }

      let(:model) { create(:proposal_component) }
      let!(:models) { create_list(:proposal, 3, :published, component: model) }

      context "when filtered by published_at" do
        include_examples "connection has before/since input filter", "proposals", "published"
      end

      context "when date is before the creation date of the proposals" do
        let(:query) do
          %(
            query {
              proposals(filter: { createdAt: "#{2.days.ago.to_date}"  }) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds nothing" do
          ids = response["proposals"]["nodes"].map { |node| node["id"] }
          expect(ids).to eq([])
        end
      end

      context "when date is equal to the creation date of the proposals" do
        let(:query) do
          %(
            query {
              proposals(filter: { createdAt: "#{models.first.created_at.to_date}"  }) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds the model" do
          ids = response["proposals"]["nodes"].map { |node| node["id"] }
          expect(ids).to match_array(models.map(&:id).map(&:to_s))
        end
      end

      context "when date is before the updated proposal" do
        let(:query) do
          %(
            query {
              proposals(filter: { updatedAt: "#{2.days.ago.to_date}"  }) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds nothing" do
          ids = response["proposals"]["nodes"].map { |node| node["id"] }
          expect(ids).to eq([])
        end
      end

      context "when date is equal to the updated proposal" do
        let(:query) do
          %(
            query {
              proposals(filter: { updatedAt: "#{models.first.updated_at.to_date}"  }) {
                nodes {
                  id
                }
              }
            }
          )
        end

        it "finds the model" do
          ids = response["proposals"]["nodes"].map { |node| node["id"] }
          expect(ids).to match_array(models.map(&:id).map(&:to_s))
        end
      end
    end
  end
end
