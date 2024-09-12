# frozen_string_literal: true

require "rails_helper"

module Decidim::Meetings
  describe ExportMeetingRegistrations do
    subject { described_class.new(meeting, format, user) }

    let(:author) { create :user, :confirmed }
    let(:meeting) { create :meeting }
    let(:admin_user) { create :user, :admin }
    let(:common_user) { create :user, :confirmed }

    shared_examples "exports the meeting registrations" do
      it "exports the meeting registrations" do
        exporter_double = double(export: true)
        class_double = double(new: exporter_double)
        allow(Decidim::Exporters)
          .to receive(:find_exporter)
          .with(format)
          .and_return(class_double)

        subject.call
      end
    end

    shared_examples "does not export the meeting registrations" do
      it "does not export the meeting registrations" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    shared_examples "traces the action" do
      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with(:export_registrations, meeting, user)
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count).by(1)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end

    context "when user is admin" do
      let(:user) { admin_user }

      %w(CSV JSON Excel).each do |format|
        context "and format is #{format}" do
          let(:format) { format }

          it_behaves_like "exports the meeting registrations"
          it_behaves_like "traces the action"
        end
      end
    end

    context "when user is the author of the meeting" do
      let(:user) { author }

      before do
        meeting.update(author: author) # Corrigindo a associação do autor ao meeting
      end

      %w(CSV JSON Excel).each do |format|
        context "and format is #{format}" do
          let(:format) { format }

          it_behaves_like "exports the meeting registrations"
        end
      end
    end

    context "when user is a common user but not the author" do
      let(:user) { common_user }

      %w(CSV JSON Excel).each do |format|
        context "and format is #{format}" do
          let(:format) { format }

          it_behaves_like "does not export the meeting registrations"
        end
      end
    end
  end
end
