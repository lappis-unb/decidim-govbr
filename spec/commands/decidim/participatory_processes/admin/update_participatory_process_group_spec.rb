# frozen_string_literal: true

require "rails_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::UpdateParticipatoryProcessGroup do
    subject { described_class.new(participatory_process_group, form) }

    let(:organization) { create :organization }
    let(:participatory_process_group) { create :participatory_process_group, organization: organization }
    let(:current_user) { create :user, :admin, :confirmed, organization: organization }
    let(:invalid) { false }
    let(:title_en) { "title es" }
    let(:developer_group) { participatory_process_group.developer_group }
    let(:participatory_processes) { create_list :participatory_process, 2, :published, organization: organization }
    let(:params) do
      {
        participatory_process_group: {
          id: participatory_process_group.id,
          title_en: title_en,
          title_es: "title es",
          title_ca: "title ca",
          description_en: "description en",
          description_es: "description es",
          description_ca: "description ca",
          hashtag: "hashtag",
          group_url: "http://example.org",
          hero_image: nil,
          current_organization: organization,
          current_user: current_user,
          participatory_process_ids: participatory_processes.map(&:id),
          developer_group: developer_group,
          local_area: participatory_process_group.local_area,
          meta_scope: participatory_process_group.meta_scope,
          target: participatory_process_group.target,
          participatory_scope: participatory_process_group.participatory_scope,
          participatory_structure: participatory_process_group.participatory_structure
        }
      }
    end
    let(:context) do
      {
        current_organization: organization,
        current_user: current_user,
        process_group_id: participatory_process_group.id
      }
    end
    let(:form) do
      Admin::ParticipatoryProcessGroupForm.from_params(params).with_context(context)
    end

    context "when the form is not valid" do
      let(:title_en) { nil }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end

      it "doesn't update the participatory group process" do
        subject.call
        participatory_process_group.reload

        expect(participatory_process_group.title["en"]).not_to eq("title es")
      end

      it "adds errors to the form" do
        subject.call
        expect(form.errors[:title_en]).not_to be_empty
      end
    end

    context "when everything is ok" do
      let(:title_en) { "new_title" }
      let(:developer_group) { { en: "new developer group" } }

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "updates the participatory group process" do
        expect { subject.call }.to broadcast(:ok)
        participatory_process_group.reload

        expect(participatory_process_group.title["en"]).to eq("new_title")
        expect(participatory_process_group.developer_group["en"]).to eq("new developer group")
      end

      it "traces the creation", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with(
            "update",
            Decidim::ParticipatoryProcessGroup,
            current_user
          ).and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)

        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
        expect(action_log.version.event).to eq "update"
      end

      context "when it has relationship with users" do
        let!(:admin_user) do
          create(:user, :confirmed, organization: organization, participatory_process_group: participatory_process_group, decidim_participatory_process_group_role: "admin")
        end
        let!(:moderator_user) do
          create(:user, :confirmed, organization: organization, participatory_process_group: participatory_process_group, decidim_participatory_process_group_role: "moderator")
        end
        let(:user_roles) { ->(user) { Decidim::ParticipatoryProcessUserRole.where(user: user).map(&:role) } }

        it "creates user roles for all associated processes" do
          expect { subject.call }.to change(Decidim::ParticipatoryProcessUserRole, :count).by(4)
          expect(user_roles.call(admin_user)).to all(eq("admin"))
          expect(user_roles.call(moderator_user)).to all(eq("moderator"))
        end

        context "when it already has some process user roles" do
          let(:participatory_process_group) { create :participatory_process_group, :with_participatory_processes, organization: organization }

          before do
            participatory_process_group.participatory_processes.each do |participatory_process|
              create :participatory_process_user_role, user: admin_user, participatory_process: participatory_process, role: "moderator"
            end
          end

          it "update previous process user roles" do
            expect(participatory_process_group.participatory_processes.size).to eq(2)
            expect { subject.call }.to change { Decidim::ParticipatoryProcessUserRole.where(user: admin_user).map(&:role) }.from(%w(moderator moderator)).to(%w(admin admin))
          end

          it "create missing user roles" do
            expect(participatory_process_group.participatory_processes.size).to eq(2)
            expect { subject.call }.to change(Decidim::ParticipatoryProcessUserRole, :count).by(2)
          end
        end
      end
    end
  end
end
