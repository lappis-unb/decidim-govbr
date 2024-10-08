# frozen_string_literal: true

require "rails_helper"

module Decidim::Admin
  describe UpdateComponent do
    let!(:participatory_process) { create(:participatory_process, :with_steps) }
    let(:step) { participatory_process.steps.first }
    let!(:component) { create(:component, :with_one_step, participatory_space: participatory_process) }
    let(:manifest) { component.manifest }
    let(:user) { create :user }
    let!(:current_participatory_space) { create(:participatory_process, :with_steps) }

    let(:form) do
      instance_double(
        ComponentForm,
        name: {
          en: "My components",
          pt_BR: "Meus componentes"
        },
        singular_name: {
            en: "My component",
            pt_BR: "Meu componente"
        },
        weight: 3,
        invalid?: !valid,
        valid?: valid,
        hide_in_menu: false,
        settings: {
          dummy_global_attribute1: true,
          dummy_global_attribute2: false,
          readonly_attribute: false
        },
        default_step_settings: {
          step.id.to_s => {
            dummy_step_attribute1: true,
            dummy_step_attribute2: false,
            readonly_step_attribute: false
          }
        },
        step_settings: {
          step.id.to_s => {
            dummy_step_attribute1: true,
            dummy_step_attribute2: false,
            readonly_step_attribute: false
          }
        },
        menu_name: {
          en: "My components",
          pt_BR: "Meus componentes"
        }
      )
    end

    describe "when valid" do
      let(:valid) { true }

      it "broadcasts :ok and updates the component (except the readonly attribute)" do
        expect do
          described_class.call(form, component, user, current_participatory_space)
        end.to broadcast(:ok)

        expect(component["name"]["en"]).to eq("My components")
        expect(component["name"]["pt_BR"]).to eq("Meus componentes")
        expect(component["singular_name"]["en"]).to eq("My component")
        expect(component["singular_name"]["pt_BR"]).to eq("Meu componente")
        expect(component["menu_name"]["en"]).to eq("My components")
        expect(component["menu_name"]["pt_BR"]).to eq("Meus componentes")

        expect(component.weight).to eq(3)
        expect(component.settings.dummy_global_attribute1).to be(true)
        expect(component.settings.dummy_global_attribute2).to be(false)
        expect(component.settings.readonly_attribute).to be(true)

        step_settings = component.step_settings[step.id.to_s]
        expect(step_settings.dummy_step_attribute1).to be(true)
        expect(step_settings.dummy_step_attribute2).to be(false)
        expect(step_settings.readonly_step_attribute).to be(true)
      end

      it "fires the hooks" do
        results = {}

        manifest.on(:update) do |component|
          results[:component] = component
        end

        described_class.call(form, component, user, current_participatory_space)

        component = results[:component]
        expect(component["name"]["en"]).to eq("My components")
        expect(component["name"]["pt_BR"]).to eq("Meus componentes")
        expect(component["singular_name"]["en"]).to eq("My component")
        expect(component["singular_name"]["pt_BR"]).to eq("Meu componente")
        expect(component).to be_persisted
      end

      it "broadcasts the previous and current settings" do
        expect do
          described_class.call(form, component, user, current_participatory_space)
        end.to broadcast(
          :ok,
          true,
          hash_including(
            "global" => kind_of(Hash),
            "default_step" => kind_of(Hash)
          ),
          hash_including(
            "global" => kind_of(Hash),
            "default_step" => kind_of(Hash),
            "steps" => kind_of(Hash)
          )
        )
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with("update", Decidim::Component, user)
          .and_call_original

        expect { described_class.call(form, component, user, current_participatory_space) }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.action).to eq("update")
        expect(action_log.version).to be_present
      end
    end

    describe "when invalid" do
      let(:valid) { false }

      it "does not update the component" do
        expect do
          described_class.call(form, component, user, current_participatory_space)
        end.to broadcast(:invalid)

        component.reload
        expect(component["name"]["en"]).not_to eq("My components")
        expect(component["name"]["pt_BR"]).not_to eq("Meus componentes")
        expect(component["singular_name"]).to be_nil
        expect(component["singular_name"]).to be_nil
      end
    end
  end
end
