# frozen_string_literal: true

require "rails_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::ParticipatoryProcessCopyForm do
    let(:organization) { create :organization }

    describe ".from_params" do
      subject { described_class.from_params(attributes).with_context(current_organization: organization) }

      let(:slug) { "slug" }
      let(:from_template) { true }
      let(:copy_steps) { true }
      let(:copy_categories) { true }
      let(:copy_components) { true }
      let(:title) do
        {
          'pt-BR': "Titulo",
          en: "Title",
          es: "Título"
        }
      end
      let(:attributes) do
        {
          slug: slug,
          from_template: from_template,
          copy_steps: copy_steps,
          copy_categories: copy_categories,
          copy_components: copy_components,
          title: title
        }
      end

      context "when everything is ok" do
        it { is_expected.to be_valid }
      end

      context "when title is blank" do
        let(:title) { nil }

        it { is_expected.to be_invalid }
      end

      context "when slug is blank" do
        let(:slug) { nil }

        it { is_expected.to be_invalid }
      end

      context "when slug is not unique" do
        let!(:participatory_process) { create :participatory_process, organization: organization, slug: slug }

        it { is_expected.to be_invalid }
      end
    end

    describe ".from_model" do
      subject { described_class.from_model(participatory_process).with_context(current_organization: organization) }

      let(:is_template?) { true }
      let(:participatory_process) { create :participatory_process, organization: organization, is_template: is_template? }

      context "when participatory process is a template" do
        it { is_expected.to have_attributes(slug: "", from_template: true, copy_steps: true, copy_categories: true, copy_components: true) }
      end

      context "when participatory process is not a template" do
        let(:is_template?) { false }

        it { is_expected.to have_attributes(slug: "", from_template: nil, copy_steps: nil, copy_categories: nil, copy_components: nil) }
      end
    end
  end
end