# frozen_string_literal: true

require "rails_helper"

module Decidim
  module ParticipatoryProcesses
    module Admin
      describe ParticipatoryProcessForm do
        subject { described_class.from_params(attributes).with_context(current_organization: organization) }

        let(:organization) { create :organization }
        let(:title) do
          {
            en: "Title",
            es: "Título",
            ca: "Títol"
          }
        end
        let(:weight) { 1 }
        let(:description) do
          {
            en: "Description",
            es: "Descripción",
            ca: "Descripció"
          }
        end
        let(:slug) { "slug" }
        let(:attachment) { upload_test_file(Decidim::Dev.test_file("city.jpeg", "image/jpeg")) }
        let(:show_metrics) { true }
        let(:show_statistics) { true }
        let(:attributes) do
          {
            "participatory_process" => {
              "id" => process_id,
              "title_en" => title[:en],
              "title_es" => title[:es],
              "title_ca" => title[:ca],
              "weight" => weight,
              "description_en" => description[:en],
              "description_es" => description[:es],
              "description_ca" => description[:ca],
              "hero_image" => attachment,
              "banner_image" => attachment,
              "slug" => slug,
              "show_metrics" => show_metrics,
              "show_statistics" => show_statistics,
              "initial_page_component_id" => initial_page_component_id,
              "initial_page_type" => initial_page_type
            }
          }
        end
        let!(:homes) { create :homes_component, id: initial_page_component_id, participatory_space: create(:participatory_process, id: process_id, organization: organization) }
        let(:initial_page_component_id) { 10 }
        let(:initial_page_type) { "foo" }
        let(:process_id) { 5 }

        context "when everything is OK" do
          it { is_expected.to be_valid }

          it "infers initial page type information" do
            expect { subject.valid? }.to change(subject, :initial_page_type).from(initial_page_type).to("homes")
          end
        end

        context "when banner_image is too big" do
          before do
            organization.settings.tap do |settings|
              settings.upload.maximum_file_size.default = 5
            end
            ActiveStorage::Blob.find_signed(attachment).update(byte_size: 6.megabytes)
          end

          it { is_expected.not_to be_valid }
        end

        context "when images are not the expected type" do
          let(:attachment) { upload_test_file(Decidim::Dev.test_file("Exampledocument.pdf", "application/pdf")) }

          it { is_expected.not_to be_valid }
        end

        context "when default language in title is missing" do
          let(:title) do
            {
              ca: "Títol"
            }
          end

          it { is_expected.to be_invalid }
        end

        context "when default language in subtitle is missing" do
          let(:subtitle) do
            {
              ca: "Subtítol"
            }
          end

          it { is_expected.to be_valid }
        end

        context "when default language in description is missing" do
          let(:description) do
            {
              ca: "Descripció"
            }
          end

          it { is_expected.to be_invalid }
        end

        context "when default language in short_description is missing" do
          let(:short_description) do
            {
              ca: "Descripció curta"
            }
          end

          it { is_expected.to be_valid }
        end

        context "when slug is missing" do
          let(:slug) { nil }

          it { is_expected.to be_invalid }
        end

        context "when slug is not valid" do
          let(:slug) { "123" }

          it { is_expected.to be_invalid }
        end

        context "when slug is not unique" do
          context "and process in the same organization" do
            before do
              create(:participatory_process, slug: slug, organization: organization)
            end

            it "is not valid" do
              expect(subject).not_to be_valid
              expect(subject.errors[:slug]).not_to be_empty
            end
          end

          context "and process in another organization" do
            before do
              create(:participatory_process, slug: slug)
            end

            it "is valid" do
              expect(subject).to be_valid
            end
          end
        end
      end
    end
  end
end
