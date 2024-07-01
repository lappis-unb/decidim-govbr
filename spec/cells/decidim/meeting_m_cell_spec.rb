# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Meetings
    describe MeetingMCell, type: :cell do
      describe "#finished?" do
        subject { meeting_cell.finished? }

        context "when the meeting has ended(after end time)" do
          let(:meeting) { create(:meeting, end_time: Time.current - 1) }
          let(:meeting_cell) { cell("decidim/meetings/meeting_m", meeting) }

          it { is_expected.to be true }
        end

        context "when the meeting is open(before end time)" do
          let(:meeting) { create(:meeting, end_time: Time.current + 1) }
          let(:meeting_cell) { cell("decidim/meetings/meeting_m", meeting) }

          it { is_expected.to be false }
        end
      end
    end
  end
end