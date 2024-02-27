# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe CreateMediaLink do
        subject { described_class.new(form, current_user, participatory_space) }

        let(:participatory_space) { create(:participatory_process) }
        let!(:current_user) { create :user, :confirmed, organization: participatory_space.organization }

        let(:title) { generate_localized_title }
        let(:date) { 5.days.from_now }
        let(:link) { Faker::Internet.url }
        let(:form_klass) { Decidim::Govbr::Admin::MediaLinkForm }
        let(:form_params) do
          {
            participatory_space_media_link: {
              title: title,
              weight: 1,
              link: link,
              date: date
            }
          }
        end

        let(:form) do
          form_klass.from_params(
            form_params
          ).with_context(
            current_user: current_user,
            current_organization: participatory_space.organization
          )
        end

        context "when title is absent" do
          let(:title) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when date is absent" do
          let(:date) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when link is invalid" do
          let(:link) { "this is not a link bro" }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        shared_examples "when everything is ok" do
          let(:media_link) { Decidim::Govbr::MediaLink.last }

          it "creates a media link" do
            expect { subject.call }.to change(Decidim::Govbr::MediaLink, :count).by(1)
          end

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "sets the participatory_space" do
            subject.call
            expect(media_link.participatory_space).to eq participatory_space
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with(
                :create,
                Decidim::Govbr::MediaLink,
                current_user,
                hash_including(resource: hash_including(:title))
              )
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
          end
        end

        context "when participatory space is participatory process," do
          let(:participatory_space) { create(:participatory_process) }

          include_examples "when everything is ok"
        end

        context "when participatory space is assembly," do
          let(:participatory_space) { create(:assembly) }

          include_examples "when everything is ok"
        end
      end
    end
  end
end
