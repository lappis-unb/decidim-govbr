# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    describe HasCustomShowPage do
      subject { dummy_class.new(participatory_space) }

      let(:dummy_class) do
        Class.new do
          include HasCustomShowPage

          attr_accessor :current_participatory_space

          def initialize(current_participatory_space)
            @current_participatory_space = current_participatory_space
          end

          def redirect_to(arg)
            arg
          end

          def decidim_participatory_space_homes_path(dummy_participatory_space, dummy_component)
            "/#{dummy_participatory_space.class}/#{dummy_participatory_space.id}/homes/#{dummy_component.id}"
          end

          def decidim_participatory_space_pages_path(dummy_participatory_space, dummy_component)
            "/#{dummy_participatory_space.class}/#{dummy_participatory_space.id}/pages/#{dummy_component.id}"
          end
        end
      end

      let!(:page_component) { create :page_component, id: actual_pages_component_id, participatory_space: participatory_space }
      let(:actual_pages_component_id) { 10 }

      let!(:homes_component) { create :homes_component, id: actual_homes_component_id, participatory_space: participatory_space }
      let(:actual_homes_component_id) { 20 }

      let(:page_type) { "pages" }

      shared_examples "redirect to examples" do
        describe "#redirect_to_custom_show_page_if_necessary" do
          subject { dummy_class.new(participatory_space).redirect_to_custom_show_page_if_necessary }

          context "when page is default" do
            let(:page_type) { "default" }
            let(:component_id) { 0 }

            it { is_expected.to be_nil }
          end

          context "when page type is pages" do
            let(:page_type) { "pages" }

            context "and component id does not belong to a page component" do
              let(:component_id) { 0 }

              it { is_expected.to be_nil }
            end

            context "and component id belongs to a valid page component" do
              let(:component_id) { actual_pages_component_id }

              it { is_expected.to eq("/#{participatory_space.class}/#{participatory_space.id}/pages/#{component_id}") }
            end
          end

          context "when page type is homes" do
            let(:page_type) { "homes" }

            context "and component id does not belong to a home component" do
              let(:component_id) { 0 }

              it { is_expected.to be_nil }
            end

            context "and component id belongs to a valid home component" do
              let(:component_id) { actual_homes_component_id }

              it { is_expected.to eq("/#{participatory_space.class}/#{participatory_space.id}/homes/#{component_id}") }
            end
          end
        end
      end

      include_examples "redirect to examples" do
        let(:participatory_space) { create :participatory_process, :with_steps, initial_page_component_id: component_id, initial_page_type: page_type }
      end

      include_examples "redirect to examples" do
        let(:participatory_space) { create :assembly, initial_page_component_id: component_id, initial_page_type: page_type }
      end
    end
  end
end