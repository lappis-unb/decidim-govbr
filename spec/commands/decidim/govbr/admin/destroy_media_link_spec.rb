# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe DestroyMediaLink, versioning: true do
        subject { described_class.new(media_link, current_user) }

        let(:participatory_space) { create(:participatory_process) }
        let(:media_link) { create :govbr_media_link, participatory_space: participatory_space }
        let!(:current_user) { create :user, :confirmed, organization: participatory_space.organization }

        context "when everything is ok" do
          let(:log_info) do
            {
              resource: {
                title: media_link.title
              },
              participatory_space: {
                title: participatory_space.title
              }
            }
          end

          it "destroys the media link" do
            subject.call
            expect { media_link.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it "traces the action" do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with("delete", media_link, current_user, log_info)
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)

            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
            expect(action_log.version.event).to eq "destroy"
          end
        end
      end
    end
  end
end
