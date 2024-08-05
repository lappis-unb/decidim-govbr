# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    describe HasCustomShowPage do
      subject { dummy_class.new(participatory_space) }

      let(:dummy_class) do
        Class.new do
          def self.helper_method(*_args, **_kwargs); end

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

          def render(template:)
            {
              template: template,
              objects: instance_variables_values
            }
          end

          def instance_variables_values
            instance_variables.to_h { |variable| [variable, instance_variable_get(variable)] }
          end
        end
      end

      let!(:page_component) { create :page_component, id: actual_pages_component_id, participatory_space: participatory_space }
      let(:actual_pages_component_id) { 10 }
      let(:page) { create :page, component: page_component }

      let!(:homes_component) { create :homes_component, id: actual_homes_component_id, participatory_space: participatory_space }
      let(:actual_homes_component_id) { 20 }
      let(:home) { create :home, component: homes_component }

      let!(:proposal_component) { create :proposal_component, id: actual_proposal_component_id, participatory_space: participatory_space }
      let(:actual_proposal_component_id) { 30 }
      let(:proposal) { create :proposal, component: proposal_component }

      let!(:meeting_component) { create :meeting_component, id: actual_meeting_component_id, participatory_space: participatory_space }
      let(:actual_meeting_component_id) { 40 }
      let(:meeting) { create :meeting, component: meeting_component }

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

          context "when page type is a valid component" do
            context "when page type is a proposal" do
              let(:page_type) { "proposals" }

              context "and component id does not belong to a page component" do
                let(:component_id) { 0 }

                it { is_expected.to be_nil }
              end

              context "and component id belongs to a valid page component" do
                let(:component_id) { actual_proposal_component_id }

                it { is_expected.to eq("/#{participatory_space.class}/#{participatory_space.id}/pages/#{component_id}") }
              end
            end

            context "when page type is a meeting" do
              let(:page_type) { "meetings" }

              context "and component id does not belong to a page component" do
                let(:component_id) { 0 }

                it { is_expected.to be_nil }
              end

              context "and component id belongs to a valid page component" do
                let(:component_id) { actual_meeting_component_id }

                it { is_expected.to eq("/#{participatory_space.class}/#{participatory_space.id}/pages/#{component_id}") }
              end
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

      shared_examples "render examples" do
        describe "#render_custom_show_page_if_necessary" do
          subject { dummy_class.new(participatory_space).render_custom_show_page_if_necessary }

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
              subject { dummy_class.new(participatory_space) }
              let(:component_id) { actual_pages_component_id }

              it "set the page component dependencies" do
                expect(page).not_to be_nil
                expect(subject.render_custom_show_page_if_necessary)
                  .to match(hash_including(
                              template: "decidim/pages/application/show",
                              objects: hash_including(
                                '@page': page
                              )
                            ))
              end
            end
          end

          context "when page type is homes" do
            let(:page_type) { "homes" }

            context "and component id does not belong to a homes component" do
              let(:component_id) { 0 }

              it { is_expected.to be_nil }
            end
          end
        end
      end

      include_examples "render examples" do
        let(:participatory_space) { create :participatory_process, :with_steps, initial_page_component_id: component_id, initial_page_type: page_type }
      end

      include_examples "render examples" do
        let(:participatory_space) { create :assembly, initial_page_component_id: component_id, initial_page_type: page_type }
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
