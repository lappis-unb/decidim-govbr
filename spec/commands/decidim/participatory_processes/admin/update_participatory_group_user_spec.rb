# frozen_string_literal: true

require "rails_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::UpdateParticipatoryProcessGroupUser do
    subject { described_class.new(current_user, form) }

    let(:organization) { create :organization }
    let(:participatory_process_group) { create :participatory_process_group, :with_participatory_processes, organization: organization }
    let(:current_user) { create :user, :admin, :confirmed, organization: organization }
    let(:user) { create :user, :confirmed, organization: organization }
    let(:params) do
      {
        participatory_process_group_user: {
          email: user.email,
          role: "admin",
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
    let(:form) { Admin::ParticipatoryProcessGroupUserForm.from_params(params).with_context(context) }

    context "when form is not valid" do
      it "broadcasts invalid" do
        allow(form).to receive(:valid?).and_return(false)
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when participatory process group is not present" do
      let(:participatory_process_group) { nil }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when everything is ok" do
      let(:user_roles) { Decidim::ParticipatoryProcessUserRole.all }

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates user roles" do
        expect { subject.call }.to change(Decidim::ParticipatoryProcessUserRole, :count).by(2)
        expect(user_roles.map(&:role)).to all(eq("admin"))
      end

      it "traces the action" do
        expect { subject.call }.to change(Decidim::ActionLog, :count).by(2)
      end

      context "when user already has some roles" do
        let(:some_participatory_process) { participatory_process_group.participatory_processes.last }

        before { create :participatory_process_user_role, user: user, participatory_process: some_participatory_process, role: "colaborator" }
      end
    end
  end
end