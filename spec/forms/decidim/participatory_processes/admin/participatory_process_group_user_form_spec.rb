# frozen_string_literal: true

require "rails_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::ParticipatoryProcessGroupUserForm do
    subject { described_class.from_params(attributes) }

    let(:organization) { create :organization }
    let(:participatory_process_group) { create :participatory_process_group, organization: organization }
    let(:email) { "user@email.com" }
    let(:participatory_process_group_id) { participatory_process_group.id }
    let(:role) { "admin" }
    let(:attributes) do
      {
        participatory_process_group_id: participatory_process_group_id,
        email: email,
        role: role
      }
    end

    context "when email does not belong to any user" do
      let(:email) { "fake@email.com" }

      it { is_expected.to be_invalid }
    end

    context "when email is not present" do
      let(:email) { nil }

      it { is_expected.to be_invalid }
    end

    context "when user email belongs to a user that already takes part of a different group" do
      let(:email) { "another_user@email.com" }
      let!(:another_user) { create :user, :confirmed, email: email, participatory_process_group: another_group }
      let!(:another_group) { create :participatory_process_group, organization: organization }

      it { is_expected.to be_invalid }
    end

    context "when role is not present" do
      let(:role) { nil }

      it { is_expected.to be_invalid }
    end

    context "when participatory_process_group_id is not present" do
      let(:participatory_process_group_id) { nil }

      it { is_expected.to be_invalid }
    end

    context "when eveything is ok" do
      let!(:user) { create :user, :confirmed, email: email, organization: organization }

      it { is_expected.to be_valid }
    end
  end
end