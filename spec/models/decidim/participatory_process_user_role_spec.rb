require 'rails_helper'

module Decidim
  describe ParticipatoryProcessUserRole do
    subject { participatory_process_user_role }
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }
    let(:participatory_process) { create(:participatory_process, slug: "example", organization: organization) }
    let(:participatory_process_user_role) { build(:participatory_process_user_role, user: user, participatory_process: participatory_process) }

    context "when user and participatory process are in same organization" do
      it "creates a valid role" do
        expect(participatory_process_user_role).to be_valid
        expect(participatory_process_user_role.errors.any?).to be false
      end
    end

    context "when user and participatory process are not unique" do
      let!(:new_participatory_process_user_role) do
        create(
          :participatory_process_user_role, user: user,
                                            participatory_process: participatory_process,
                                            role: "admin"
        )
      end

      it "does not create a role" do
        expect(subject).to be_invalid
        expect(subject.errors[:role]).to eq ["has already been taken"]
      end
    end

    context "when user and process are not in same organization" do
      let(:new_organization) { create(:organization) }
      let(:user) { create(:user, organization: new_organization) }

      it "does not create a role" do
        expect(subject).to be_invalid
        expect(subject.errors.any?).to be true
      end
    end
  end
end