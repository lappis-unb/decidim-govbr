# frozen_string_literal: true

require "rails_helper"

module Decidim::Admin
  describe CreateComponent do
    subject { described_class.new(form) }

    let(:manifest) { Decidim.find_component_manifest(:dummy) }
    let(:form) do
      instance_double(
        ComponentForm,
        name: {
          en: "My proposals",
          pt_BR: "Minhas propostas"
        },
        singular_name: {
          en: "My proposal",
          pt_BR: "Minha proposta"
        },
        invalid?: !valid,
        valid?: valid,
        current_user: current_user,
        weight: 2,
        manifest: manifest,
        participatory_space: participatory_process,
        hide_in_menu: false,
        settings: {
          dummy_global_attribute1: true,
          dummy_global_attribute2: false
        },
        default_step_settings: {
          step.id.to_s => {
            dummy_step_attribute1: true,
            dummy_step_attribute2: false
          }
        },
        step_settings: {
          step.id.to_s => {
            dummy_step_attribute1: true,
            dummy_step_attribute2: false
          }
        },
        menu_name: {
          en: "My proposals",
          pt_BR: "Minhas propostas"
        },
        enable_comments_attachment: true
      )
    end

    let(:participatory_process) { create(:participatory_process, :with_steps) }
    let(:step) { participatory_process.steps.first }
    let(:current_user) { create :user, organization: participatory_process.organization }

    describe "when valid" do
      let(:valid) { true }

      it "broadcasts :ok and creates the component" do
        expect do
          subject.call
        end.to broadcast(:ok)

        expect(participatory_process.components).not_to be_empty

        component = participatory_process.components.first
        expect(component.settings.dummy_global_attribute1).to be(true)
        expect(component.settings.dummy_global_attribute2).to be(false)
        expect(component.weight).to eq 2

        step_settings = component.step_settings[step.id.to_s]
        expect(step_settings.dummy_step_attribute1).to be(true)
        expect(step_settings.dummy_step_attribute2).to be(false)
        expect(component.enable_comments_attachment).to be(true)
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:create!)
          .with(Decidim::Component, current_user, a_kind_of(Hash))
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)

        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
        expect(action_log.version.event).to eq "create"
      end

      it "fires the hooks" do
        results = {}

        manifest.on(:create) do |component|
          results[:component] = component
        end

        subject.call

        component = results[:component]
        expect(component.name["en"]).to eq("My proposals")
        expect(component.name["pt_BR"]).to eq("Minhas propostas")
        expect(component.singular_name["en"]).to eq("My proposal")
        expect(component.singular_name["pt_BR"]).to eq("Minha proposta")
        expect(component.menu_name["en"]).to eq("My proposals")
        expect(component.menu_name["pt_BR"]).to eq("Minhas propostas")
        expect(component).to be_persisted
        expect(component.enable_comments_attachment).to be(true)
      end
    end

    describe "when invalid" do
      let(:valid) { false }

      it "broadcasts invalid and does not create the component" do
        expect do
          subject.call
        end.to broadcast(:invalid)

        expect(participatory_process.components).to be_empty
      end
    end
  end
end
