# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe DestroyUser do
        subject { described_class.new(user, current_user) }
        let(:organization) { create :organization, super_admins: super_admins }
        let(:super_admins) { [user_email] }
        let(:user) { create :user, :confirmed, organization: organization }
        let!(:authorization) { create :authorization, user: user }
        let!(:current_user) { create :user, :confirmed, :admin, email: user_email, organization: organization }
        let(:user_email) { "test@email.com" }

        context "when current user is not super admin" do
          let(:super_admins) { [] }

          it "does not destroy user" do
            expect { subject.call }.to broadcast(:invalid, :super_admin)
            expect { authorization.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
            expect { user.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when target user is admin" do
          let(:user) { create :user, :confirmed, :admin, organization: organization }

          it "does not destroy user" do
            expect { subject.call }.to broadcast(:invalid, :target_user_is_admin)
            expect { authorization.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
            expect { user.reload }.not_to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when user is super admin and target user is not admin" do
          it "destroys user" do
            expect { subject.call }.to broadcast(:ok)
            expect { authorization.reload }.to raise_error(ActiveRecord::RecordNotFound)
            expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end