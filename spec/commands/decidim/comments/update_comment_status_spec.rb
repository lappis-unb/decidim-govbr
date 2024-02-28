# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Comments
    describe UpdateCommentStatus do
      let(:organization) { create(:organization) }
      let(:participatory_process) { create(:participatory_process, organization: organization) }
      let(:component) { create(:component, participatory_space: participatory_process) }
      let(:author) { create(:user, organization: organization, admin: true) }
      let(:common_user) { create(:user, organization: organization, admin: false)}
      let(:dummy_resource) { create :dummy_resource, component: component }
      let(:commentable) { dummy_resource }
      let(:comment) { create :comment, author: author, commentable: commentable }
      let(:body) { "This is a reasonable comment" }
      let(:params) do
        {
          id: comment.id,
          comment: {
            status: 'accepted'
          }
        }
      end
      let(:current_user) { author }
      let(:command) { described_class.new(comment, current_user, params) }

      describe "call" do
        describe "when user is admin" do
          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "updates the comment" do
            command.call
            comment.reload
            expect(comment.status).to eq("accepted")
          end
        end

        describe "when user is not an admin" do
          let(:invalid_command) { described_class.new(comment, common_user, params) }

          it "broadcasts invalid" do
            expect { invalid_command.call }.to broadcast(:invalid)
          end
        end
      end
    end
  end
end
