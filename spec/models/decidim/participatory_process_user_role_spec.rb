require 'rails_helper'

module Decidim
  describe ParticipatoryProcessUserRole do
    subject { participatory_process_user_role }
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }
    let(:participatory_process) { create(:participatory_process, slug: "example", organization: organization) }
    let(:participatory_process_user_role) { create(:participatory_process_user_role, user: user, participatory_process: participatory_process) }

    context "User and participatory process are in same organization" do

      it "creates a valid role" do
        
        expect(participatory_process_user_role).to be_valid
        expect(participatory_process_user_role.errors.any?).to be false
      end
    end
    
    context "User and participatory process are not unique" do
      let(:new_participatory_process_user_role) { create(
        :participatory_process_user_role, user: user, 
        participatory_process: participatory_process, 
        role: "admin"
      )}
      
      it "does not create a role" do
        expect(new_participatory_process_user_role).to be_invalid
      end
    end
  end
end