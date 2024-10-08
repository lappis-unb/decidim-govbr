# frozen_string_literal: true

require "rails_helper"

module Decidim
  describe InviteUser do
    let(:organization) { create(:organization) }
    let!(:admin) { create(:user, :confirmed, :admin, organization: organization) }
    let(:form) do
      Decidim::InviteUserForm.from_params(
        name: "Old man",
        email: "oldman@email.com",
        organization: organization,
        role: "admin",
        invited_by: admin,
        invitation_instructions: "invite_admin",
        participatory_process_group_id: participatory_process_group_id
      ).with_context(
        organization: organization, current_user: admin
      )
    end
    let!(:command) { described_class.new(form) }
    let(:participatory_process_group_id) { nil }
    let(:invited_user) { User.where(organization: organization).last }

    context "when a user with the given email already exists in the same organization" do
      let!(:user) { create(:user, email: form.email, organization: organization) }

      it "does not create another user" do
        expect do
          command.call
        end.not_to change(User, :count)
      end

      it "broadcasts ok and the user" do
        expect do
          command.call
        end.to broadcast(:ok, user)
      end

      it "sends a notification email to the user" do
        expect do
          command.call
        end.to have_enqueued_email(Decidim::Govbr::PromotedToAdminMailer, :notification)
      end
    end

    context "when a user with the given email already exists in a different organization" do
      before do
        create(:user, :confirmed, email: form.email)
      end

      it "creates another user" do
        expect do
          command.call
        end.to change(User, :count).by(1)
      end

      it "broadcasts ok and the user" do
        expect do
          command.call
        end.to broadcast(:ok, an_instance_of(Decidim::User))
      end

      it "does not send the confirmation email" do
        clear_enqueued_jobs
        command.call

        jobs = ActiveJob::Base.queue_adapter.enqueued_jobs
        expect(jobs.count).to eq 1

        _, _, _, queued_user, _, queued_options = ActiveJob::Arguments.deserialize(jobs.first[:args])

        expect(queued_user).to eq(invited_user)
        expect(queued_options).to eq(invitation_instructions: "invite_admin")
      end
    end

    it "adds the roles for the user" do
      command.call

      expect(invited_user).to be_admin
    end

    context "when a user does not exist for the given email" do
      it "creates it" do
        expect do
          command.call
        end.to change(User, :count).by(1)

        expect(invited_user.email).to eq(form.email)
      end

      it "broadcasts ok and the user" do
        expect do
          command.call
        end.to broadcast(:ok)
      end

      it "sends an invitation email with the given instructions" do
        clear_enqueued_jobs
        command.call

        _, _, _, queued_user, _, queued_options = ActiveJob::Arguments.deserialize(ActiveJob::Base.queue_adapter.enqueued_jobs.first[:args])

        expect(queued_user).to eq(invited_user)
        expect(queued_options).to eq(invitation_instructions: "invite_admin")
      end
    end

    context "when a user needs entity fields" do
      let(:participatory_process_group) { create :participatory_process_group, :with_participatory_processes, organization: organization }
      let(:participatory_process_group_id) { participatory_process_group&.id }

      it "adds a user to process group" do
        command.call

        invited_user.reload

        expect(Decidim::ParticipatoryProcessUserRole.all.map(&:decidim_user_id)).to all eq(invited_user.id)
      end
    end
  end
end
