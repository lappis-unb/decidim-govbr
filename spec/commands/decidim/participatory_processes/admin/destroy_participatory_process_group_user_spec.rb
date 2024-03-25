# frozen_string_literal: true

require "rails_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::DestroyParticipatoryProcessGroupUser do
    subject { described_class.new(participatory_process_group, current_user, user) }

    let(:organization) { create :organization }
    let(:participatory_process_group) { create :participatory_process_group, :with_participatory_processes, organization: organization }
    let(:current_user) { create :user, :admin, :confirmed, organization: organization }
    let(:user) { create :user, :confirmed, organization: organization, participatory_process_group: participatory_process_group }

    context "when given user group is different from the actual user group" do
      let(:different_user_group) { create :participatory_process_group, organization: organization }
      let(:user) { create :user, :confirmed, organization: organization, participatory_process_group: different_user_group }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when everything is ok" do
      let(:user_roles) { Decidim::ParticipatoryProcessUserRole.all }

      before do
        participatory_process_group.participatory_processes.each do |process|
          create :participatory_process_user_role, user: user, participatory_process: process, role: "admin"
        end
      end

      it "destroy all user roles from user which belongs to the process group" do
        expect(user_roles).not_to be_empty
        expect { subject.call }.to change(Decidim::ParticipatoryProcessUserRole, :count).by(-2)
        expect(user_roles).to be_empty
      end

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "traces the action" do
        expect { subject.call }.to change(Decidim::ActionLog, :count).by(2)
      end
    end
  end
end