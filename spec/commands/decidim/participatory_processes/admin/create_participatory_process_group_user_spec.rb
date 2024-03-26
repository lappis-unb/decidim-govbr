# frozen_string_literal: true

require "rails_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::CreateParticipatoryProcessGroupUser do
    subject { described_class.new(current_user, form) }

    let(:organization) { create :organization }
    let(:current_user) { create :user, :confirmed, :admin, organization: organization }
    let(:participatory_process_group) { create :participatory_process_group, :with_participatory_processes, organization: organization }
    let(:user) { create :user, :confirmed, organization: organization }
    let(:params) do
      {
        participatory_process_group_user: {
          email: user.email,
          role: "moderator",
          participatory_process_group_id: participatory_process_group&.id
        }
      }
    end
    let(:context) do
      {
        current_organization: organization,
        current_user: current_user
      }
    end
    let(:form) do
      Admin::ParticipatoryProcessGroupUserForm.from_params(params).with_context(context)
    end

    context "when form is not valid" do
      it "broadcasts invalid" do
        allow(form).to receive(:valid?).and_return(false)
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when participatory process group is blank" do
      let(:participatory_process_group) { nil }

      it { expect { subject.call }.to broadcast(:invalid) }
    end

    context "when everything is ok" do
      let(:user_roles) { Decidim::ParticipatoryProcessUserRole.all }

      it { expect { subject.call }.to broadcast(:ok) }

      it "creates the user roles and link user to the group with the specified role" do
        expect { subject.call }.to change(Decidim::ParticipatoryProcessUserRole, :count).by(2)
        expect(user_roles.map(&:role)).to all(eq("moderator"))

        user.reload

        expect(user.participatory_process_group).to eq(participatory_process_group)
        expect(user.decidim_participatory_process_group_role).to eq("moderator")
      end

      it "traces the user role creation" do
        expect { subject.call }.to change(Decidim::ActionLog, :count).by(2)
      end

      context "when user already has user roles for some participatory process" do
        let(:some_participatory_process) { participatory_process_group.participatory_processes.last }

        before { create :participatory_process_user_role, user: user, participatory_process: some_participatory_process, role: "admin" }

        it "only creates the missing user roles" do
          expect { subject.call }.to change(Decidim::ParticipatoryProcessUserRole, :count).by(1)
        end

        it "updates the existing user roles and traces action" do
          expect { subject.call }.to(
            change { Decidim::ParticipatoryProcessUserRole.find_by(user: user, participatory_process: some_participatory_process).role }
              .from("admin")
              .to("moderator")
          )
        end

        it "traces the user role creation and modification" do
          expect { subject.call }.to change(Decidim::ActionLog, :count).by(2)
        end
      end
    end
  end
end