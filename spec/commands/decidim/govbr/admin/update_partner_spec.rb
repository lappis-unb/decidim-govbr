# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe UpdatePartner do
        subject { described_class.new(form, partner) }

        let(:form_klass) { Decidim::ParticipatoryProcesses::Admin::PartnerForm }
        let!(:partnerable) { create(:participatory_process) }
        let(:partner) { create :partner, :as_organizer, partnerable: partnerable }
        let!(:current_user) { create :user, :confirmed, organization: partnerable.organization }
        let(:logo) do
          ActiveStorage::Blob.create_and_upload!(
            io: File.open(Decidim::Dev.asset("avatar.jpg")),
            filename: "avatar.jpeg",
            content_type: "image/jpeg"
          )
        end

        let(:form_params) do
          {
            participatory_process_partner: {
              name: "New name",
              weight: 2,
              partner_type: "supporter",
              link: Faker::Internet.url,
              logo: logo
            }
          }
        end

        let!(:form) do
          form_klass.from_params(
            form_params
          ).with_context(
            current_user: current_user,
            current_organization: partnerable.organization
          )
        end

        context "when the form is not valid" do
          context "when form is invalid" do
            let(:form_params) { { participatory_process_partner: { name: nil } } }

            it "is not valid" do
              expect { subject.call }.to broadcast(:invalid)
            end
          end

          context "when image is invalid" do
            let(:logo) do
              ActiveStorage::Blob.create_and_upload!(
                io: File.open(Decidim::Dev.asset("invalid.jpeg")),
                filename: "invalid.jpeg",
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
          it "updates the partner name" do
            expect do
              subject.call
            end.to change { partner.reload && partner.name }.from(partner.name).to("New name")
          end

          it "updates the partner type" do
            expect do
              subject.call
            end.to change { partner.reload && partner.partner_type }.from(partner.partner_type).to("supporter")
          end

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:update!)
              .with(partner, current_user, kind_of(Hash), hash_including(resource: hash_including(:title)))
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
