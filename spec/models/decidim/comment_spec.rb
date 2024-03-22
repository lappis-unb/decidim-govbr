# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Comments
    describe Comment do
      let(:component) { create(:component, manifest_name: "dummy") }
      let!(:commentable) { create(:dummy_resource, component: component) }
      let!(:author) { create(:user, organization: commentable.organization) }
      let!(:comment) { create(:comment, commentable: commentable, author: author) }
      let!(:replies) { create_list(:comment, 3, commentable: comment, root_commentable: commentable) }
      let!(:up_vote) { create(:comment_vote, :up_vote, comment: comment) }
      let!(:down_vote) { create(:comment_vote, :down_vote, comment: comment) }

      it "is valid" do
        expect(comment).to be_valid
      end

      it "comment initial status should be in_discussion when valid" do
        new_comment = build(:comment, body: "Hey this is a comment")
        expect(new_comment).to be_valid
        expect(new_comment.body).to eq("en" => "Hey this is a comment")
        expect(new_comment.status).to eq("in_discussion")
      end

      it "is valid with a hash as the body" do
        new_comment = build(:comment, body: { en: "Hey this is a comment" })
        expect(new_comment).to be_valid
        expect(new_comment.body).to eq("en" => "Hey this is a comment")
        expect(new_comment.status).to eq("in_discussion")
      end
    end
  end
end
