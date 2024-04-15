# frozen_string_literal: true

require "rails_helper"

module Decidim::Admin
  describe UpdateOrganization do
    describe "call" do
      let(:organization) { create(:organization) }
      let(:user) { create(:user, organization: organization) }
      let(:template_processes) { create_list :participatory_process, 3, organization: organization }
      let(:previous_template_processes) { create_list :participatory_process, 3, organization: organization, is_template: true }
      let(:template_processes_ids) { template_processes.map(&:id) }
      let(:params) do
        {
          organization: {
            name: "My super organization",
            reference_prefix: "MSO",
            time_zone: "Hawaii",
            default_locale: "en",
            badges_enabled: true,
            user_groups_enabled: true,
            send_welcome_notification: false,
            admin_terms_of_use_body: { en: Faker::Lorem.paragraph },
            rich_text_editor_in_public_views: true,
            machine_translation_display_priority: "translation",
            enable_machine_translations: true,
            menu_links: '{}',
            footer_menu_links: '{}',
            user_profile_survey_id: 999,
            template_processes_ids: template_processes_ids
          }
        }
      end
      let(:context) do
        {
          current_user: user,
          current_organization: organization
        }
      end
      let(:form) do
        OrganizationForm.from_params(params).with_context(context)
      end
      let(:command) { described_class.new(organization, form) }

      describe "when the form is not valid" do
        before do
          allow(form).to receive(:invalid?).and_return(true)
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "doesn't update the organization" do
          command.call
          organization.reload

          expect(organization.name).not_to eq("My super organization")
        end
      end

      context "when template processes ids are from an outsider organization" do
        let(:outsider_template_processes) { create_list :participatory_process, 3, is_template: false }
        let(:template_processes_ids) { outsider_template_processes.map(&:id) }

        it "does not update them" do
          expect(outsider_template_processes).to all have_attributes(is_template: false)
          expect { command.call }.to broadcast(:ok)
          expect(outsider_template_processes).to all have_attributes(is_template: false)
        end
      end

      describe "when the form is valid" do
        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end

        it "traces the update", versioning: true do
          expect(previous_template_processes).to all have_attributes(is_template: true)
          expect(template_processes).to all have_attributes(is_template: false)

          expect(Decidim.traceability)
            .to receive(:update!)
            .with(organization, user, a_kind_of(Hash))
            .and_call_original

          expect(Decidim.traceability)
            .to receive(:update!)
            .exactly(6).times
            .with(an_instance_of(Decidim::ParticipatoryProcess), user, hash_including(:is_template))

          expect { command.call }.to change(Decidim::ActionLog, :count)

          action_logs_version = Decidim::ActionLog.last(7).map(&:version)
          expect(action_logs_version).to all be_present
          expect(action_logs_version.map(&:event)).to all eq("update")
        end

        it "updates the organization in the organization" do
          expect { command.call }.to broadcast(:ok)
          organization.reload

          expect(organization.name).to eq("My super organization")
          expect(organization.rich_text_editor_in_public_views).to be(true)
          expect(organization.enable_machine_translations).to be(true)
          expect(organization.user_profile_survey_id).to eq(999)
        end

        it "updates templates processes" do
          expect(previous_template_processes).to all have_attributes(is_template: true)
          expect(template_processes).to all have_attributes(is_template: false)

          expect { command.call }.to broadcast(:ok)

          expect(previous_template_processes.each(&:reload)).to all have_attributes(is_template: false)
          expect(template_processes.each(&:reload)).to all have_attributes(is_template: true)
        end
      end
    end
  end
end
