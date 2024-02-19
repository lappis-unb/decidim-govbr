# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe UpdateMediaLink do
        subject { described_class.new(form, media_link) }

        let!(:participatory_space) { create(:participatory_process) }
        let(:media_link) { create :govbr_media_link, participatory_space: participatory_space }
        let!(:current_user) { create :user, :confirmed, organization: participatory_space.organization }

        let(:title) { generate_localized_title }
        let(:date) { 5.days.from_now.to_date }
        let(:link) { Faker::Internet.url }
        let(:weight) { media_link.weight + 1 }
        let(:form_klass) { Decidim::Govbr::Admin::MediaLinkForm }
        let(:form_params) do
          {
            participatory_space_media_link: {
              title: title,
              weight: weight,
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
          it "updates the media link title" do
            expect do
              subject.call
            end.to change { media_link.reload && media_link.title }.from(media_link.title).to(title)
          end

          it { expect { subject.call }.to(change { media_link.date }.from(media_link.date).to(date)) }
          it { expect { subject.call }.to(change { media_link.weight }.from(media_link.weight).to(weight)) }
          it { expect { subject.call }.to(change { media_link.link }.from(media_link.link).to(link)) }

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:update!)
              .with(media_link, current_user, kind_of(Hash), hash_including(resource: hash_including(:title)))
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
