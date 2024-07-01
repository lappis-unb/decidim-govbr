# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Meetings
    describe Meeting do
      let(:meeting) { create(:meeting) }

      it "is valid" do
        expect(meeting).to be_valid
      end

      describe "#deletable?" do
        subject { meeting.deletable? }

        context "when meeting has none interactions" do
          let(:meeting) { create(:meeting) }

          it { is_expected.to be true }
        end

        context "when meeting has comments" do
          let(:meeting) { create(:meeting, comments_count: 1) }

          it { is_expected.to be false }
        end

        context "when meeting has subscribers" do
          let(:user) { create(:user) }
          let(:meeting) { create(:meeting) }

          before do
            create(:registration, meeting: meeting, user: user)
          end

          it { is_expected.to be false }
        end

        context "when meeting has subscribers and comments" do
          let(:user) { create(:user) }
          let(:meeting) { create(:meeting, comments_count: 1) }

          before do
            create(:registration, meeting: meeting, user: user)
          end

          it { is_expected.to be false }
        end
      end
    end
  end
end