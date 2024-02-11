# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe CreatePartner do
        subject { described_class.new(form, current_user, partnerable) }

        let(:partnerable) { create :participatory_process }
        let(:user) { nil }
        let!(:current_user) { create :user, :confirmed, organization: partnerable.organization }
        let(:logo) do
          ActiveStorage::Blob.create_and_upload!(
            io: File.open(Decidim::Dev.asset("avatar.jpg")),
            filename: "avatar.jpeg",
            content_type: "image/jpeg"
          )
        end

        let(:name) { "Name" }
        let(:partner_type) { "organizer" }
        let(:form_klass) { Decidim::ParticipatoryProcesses::Admin::PartnerForm }
        let(:form_params) do
          {
            participatory_process_partner: {
              name: name,
              weight: 1,
              partner_type: partner_type,
              link: Faker::Internet.url,
              logo: logo
            }
          }
        end
        let(:form) do
          form_klass.from_params(
            form_params
          ).with_context(
            current_user: current_user,
            current_organization: partnerable.organization
          )
        end

        context "when form is not valid" do
          let(:name) { nil }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end

          context "when image is invalid" do
            let(:logo) do
              ActiveStorage::Blob.create_and_upload!(
                io: File.open(Decidim::Dev.asset("invalid.jpeg")),
                filename: "avatar.jpeg",
                content_type: "image/jpeg"
              )
            end

            it "prevents uploading" do
              expect { subject.call }.not_to raise_error
              expect { subject.call }.to broadcast(:invalid)
            end
          end
        end

        context "when everything is ok" do
          let(:partner) { Decidim::Govbr::Partner.last }

          it "creates a partner" do
            expect { subject.call }.to change(Decidim::Govbr::Partner, :count).by(1)
          end

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "sets the partner" do
            subject.call
            expect(partner.partnerable).to eq partnerable
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with(:create, Decidim::Govbr::Partner, current_user, { participatory_space: { title: partnerable.title }, resource: { title: form.name } })
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
          end
        end
      end
    end
  end
end