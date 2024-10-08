# frozen_string_literal: true

require "rails_helper"

describe Decidim::ParticipatoryProcesses::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:user) { create :user, :admin, organization: organization }
  let(:organization) { create :organization }
  let(:process) { create :participatory_process, organization: organization }
  let(:context) { {} }
  let(:permission_action) { Decidim::PermissionAction.new(**action) }
  let(:process_admin) { create :process_admin, participatory_process: process }
  let(:process_collaborator) { create :process_collaborator, participatory_process: process }
  let(:process_moderator) { create :process_moderator, participatory_process: process }
  let(:process_valuator) { create :process_valuator, participatory_process: process }
  let(:participatory_process_group) { create :participatory_process_group, organization: organization, participatory_processes: [process] }
  let(:group_admin) { create :user, participatory_process_group: participatory_process_group, decidim_participatory_process_group_role: :admin }
  let(:group_member) { create :user, participatory_process_group: participatory_process_group, decidim_participatory_process_group_role: :valuator }

  shared_examples "allows any action on subject" do |action_subject|
    context "when action subject is #{action_subject}" do
      let(:action) do
        { scope: :admin, action: :foo, subject: action_subject }
      end

      it { is_expected.to be true }
    end
  end

  shared_examples "access for role" do |access|
    case access
    when true
      it { is_expected.to be true }
    when :not_set
      it_behaves_like "permission is not set"
    else
      it { is_expected.to be false }
    end
  end

  shared_examples "access for roles" do |access|
    context "when user is org admin" do
      it_behaves_like "access for role", access[:org_admin]
    end

    context "when user is a space admin" do
      let(:user) { process_admin }

      it_behaves_like "access for role", access[:admin]
    end

    context "when user is a space collaborator" do
      let(:user) { process_collaborator }

      it_behaves_like "access for role", access[:collaborator]
    end

    context "when user is a space moderator" do
      let(:user) { process_moderator }

      it_behaves_like "access for role", access[:moderator]
    end

    context "when user is a space valuator" do
      let(:user) { process_valuator }

      it_behaves_like "access for role", access[:valuator]
    end

    context "when user is a process group member" do
      let(:user) { group_member }

      it_behaves_like "access for role", access[:group_member]
    end

    context "when user is a process group admin" do
      let(:user) { group_admin }

      it_behaves_like "access for role", access[:group_admin]
    end
  end

  context "when the action is for the public part" do
    context "when reading the admin dashboard" do
      let(:action) do
        { scope: :public, action: :read, subject: :admin_dashboard }
      end

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true,
        collaborator: true,
        moderator: true,
        valuator: true,
        group_member: true,
        group_admin: true
      )
    end

    context "when accessing global moderation" do
      subject { Decidim::Admin::Permissions.new(user, permission_action, context).permissions.allowed? }

      let(:action) do
        { scope: :admin, action: :read, subject: :global_moderation }
      end

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true,
        collaborator: false,
        moderator: true,
        valuator: false,
        group_member: :not_set,
        group_admin: :not_set
      )
    end

    context "when reading a process" do
      let(:action) do
        { scope: :public, action: :read, subject: :process }
      end
      let(:context) { { process: process } }

      context "when the user is an admin" do
        let(:user) { create :user, :admin }

        it { is_expected.to be true }
      end

      context "when the process is published" do
        let(:user) { create :user, organization: organization }

        it { is_expected.to be true }
      end

      context "when the process is not published" do
        let(:user) { create :user, organization: organization }
        let(:process) { create :participatory_process, :unpublished, organization: organization }

        context "when the user doesn't have access to it" do
          it { is_expected.to be false }
        end

        context "when the user has access to it" do
          before do
            create :participatory_process_user_role, user: user, participatory_process: process
          end

          it { is_expected.to be true }
        end
      end
    end

    context "when listing processes" do
      let(:action) do
        { scope: :public, action: :list, subject: :process }
      end

      it { is_expected.to be true }
    end

    context "when listing process groups" do
      let(:action) do
        { scope: :public, action: :list, subject: :process_group }
      end

      it { is_expected.to be true }
    end

    context "when any other action" do
      let(:action) do
        { scope: :public, action: :foo, subject: :bar }
      end

      it_behaves_like "permission is not set"
    end
  end

  context "when no user is given" do
    let(:user) { nil }
    let(:action) do
      { scope: :admin, action: :read, subject: :dummy_resource }
    end

    it_behaves_like "permission is not set"
  end

  context "when the scope is not public" do
    let(:action) do
      { scope: :foo, action: :read, subject: :dummy_resource }
    end

    it_behaves_like "permission is not set"
  end

  context "when accessing the space area" do
    let(:action) do
      { scope: :admin, action: :enter, subject: :space_area }
    end
    let(:context) { { space_name: :processes } }

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true,
      collaborator: true,
      moderator: true,
      valuator: true,
      group_member: true,
      group_admin: true
    )
  end

  context "when reading the admin dashboard from the admin part" do
    let(:action) do
      { scope: :admin, action: :read, subject: :admin_dashboard }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true,
      collaborator: true,
      moderator: true,
      valuator: true,
      group_member: true,
      group_admin: true
    )
  end

  context "when acting on process groups" do
    let(:action) do
      { scope: :admin, action: :any_action_is_accepted, subject: :process_group }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: false,
      collaborator: false,
      moderator: false,
      valuator: false,
      group_member: false,
      group_admin: false
    )
  end

  context "when acting on component data" do
    context "when exporting component data" do
      let(:action) do
        { scope: :admin, action: :export, subject: :component_data }
      end
      let(:context) { { current_participatory_space: process } }

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true,
        collaborator: :not_set,
        moderator: :not_set,
        valuator: true,
        group_member: :not_set,
        group_admin: :not_set
      )
    end

    context "when performing any other action" do
      let(:action) do
        { scope: :admin, action: :any_action_is_accepted, subject: :component_data }
      end
      let(:context) { { current_participatory_space: process } }

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true,
        collaborator: :not_set,
        moderator: :not_set,
        valuator: :not_set,
        group_member: :not_set,
        group_admin: :not_set
      )
    end
  end

  context "when reading the processes list" do
    let(:action) do
      { scope: :admin, action: :read, subject: :process_list }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true,
      collaborator: true,
      moderator: true,
      valuator: true,
      group_member: true,
      group_admin: true
    )
  end

  context "when reading a process" do
    let(:action) do
      { scope: :admin, action: :read, subject: :process }
    end
    let(:context) { { process: process } }

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true,
      collaborator: true,
      moderator: true,
      valuator: true,
      group_member: false,
      group_admin: false
    )
  end

  context "when reading a template process" do
    let(:action) do
      { scope: :admin, action: :read, subject: :process }
    end
    let(:context) { { process: create(:participatory_process, organization: organization, is_template: true) } }

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true,
      collaborator: false,
      moderator: false,
      valuator: false,
      group_member: false,
      group_admin: true
    )
  end

  context "when copying a process" do
    let(:action) do
      { scope: :admin, action: :copy, subject: :process }
    end
    let(:context) { { process: process } }

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true,
      collaborator: false,
      moderator: false,
      valuator: false,
      group_member: false,
      group_admin: true
    )
  end

  context "when reading a participatory_space" do
    let(:action) do
      { scope: :admin, action: :read, subject: :participatory_space }
    end
    let(:context) { { current_participatory_space: process } }

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: true,
      collaborator: true,
      moderator: true,
      valuator: true,
      group_member: false,
      group_admin: false
    )
  end

  context "when creating a process" do
    let(:action) do
      { scope: :admin, action: :create, subject: :process }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true,
      admin: false,
      collaborator: false,
      moderator: false,
      valuator: false,
      group_member: false,
      group_admin: false
    )
  end

  context "with a process" do
    let(:context) { { process: process } }

    context "when moderating a resource" do
      let(:action) do
        { scope: :admin, action: :foo, subject: :moderation }
      end

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true,
        collaborator: :not_set,
        moderator: true,
        valuator: :not_set,
        group_member: :not_set,
        group_admin: :not_set
      )
    end

    context "when updating a process" do
      let(:action) do
        { scope: :admin, action: :update, subject: :process }
      end

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true,
        collaborator: :not_set,
        moderator: :not_set,
        valuator: :not_set,
        group_member: :not_set,
        group_admin: :not_set
      )
    end

    context "when publishing a process" do
      let(:action) do
        { scope: :admin, action: :publish, subject: :process }
      end

      it_behaves_like(
        "access for roles",
        org_admin: true,
        admin: true,
        collaborator: :not_set,
        moderator: :not_set,
        valuator: :not_set,
        group_member: :not_set,
        group_admin: :not_set
      )
    end

    context "when user is a collaborator" do
      let(:user) { process_collaborator }

      context "when action is :preview" do
        let(:action) do
          { scope: :admin, action: :preview, subject: :dummy }
        end

        it { is_expected.to be true }
      end

      context "when action is a random one" do
        let(:action) do
          { scope: :admin, action: :foo, subject: :dummy }
        end

        it_behaves_like "permission is not set"
      end
    end

    context "when user is a process admin" do
      let(:user) { process_admin }

      context "when creating a process" do
        let(:action) do
          { scope: :admin, action: :create, subject: :process }
        end

        it { is_expected.to be false }
      end

      it_behaves_like "allows any action on subject", :attachment
      it_behaves_like "allows any action on subject", :attachment_collection
      it_behaves_like "allows any action on subject", :category
      it_behaves_like "allows any action on subject", :component
      it_behaves_like "allows any action on subject", :moderation
      it_behaves_like "allows any action on subject", :process
      it_behaves_like "allows any action on subject", :process_step
      it_behaves_like "allows any action on subject", :process_user_role
      it_behaves_like "allows any action on subject", :space_private_user
    end

    context "when user is an org admin" do
      context "when creating a process" do
        let(:action) do
          { scope: :admin, action: :create, subject: :process }
        end

        it { is_expected.to be true }
      end

      it_behaves_like "allows any action on subject", :attachment
      it_behaves_like "allows any action on subject", :attachment_collection
      it_behaves_like "allows any action on subject", :category
      it_behaves_like "allows any action on subject", :component
      it_behaves_like "allows any action on subject", :moderation
      it_behaves_like "allows any action on subject", :process
      it_behaves_like "allows any action on subject", :process_step
      it_behaves_like "allows any action on subject", :process_user_role
      it_behaves_like "allows any action on subject", :space_private_user
    end

    context "when user is a valuator" do
      let(:user) { process_valuator }

      context "when reading a component" do
        let(:action) do
          { scope: :admin, action: :read, subject: :component }
        end

        it { is_expected.to be true }
      end
    end

    context "when subject is partner" do
      let(:action) do
        {
          scope: :admin,
          action: current_action,
          subject: :partner
        }
      end

      context "and user is admin" do
        let(:user) { create :user, :admin, organization: organization }

        context "when action is read" do
          let(:current_action) { :read }

          it { is_expected.to be(true) }
        end

        context "when action is anything" do
          let(:current_action) { :foo }

          it { is_expected.to be(true) }
        end
      end

      context "and user is not admin" do
        let(:user) { create :user, organization: organization }

        context "when action is read" do
          let(:current_action) { :read }

          it { is_expected.not_to be(true) }
        end

        context "when action is anything" do
          let(:current_action) { :foo }

          it { is_expected.not_to be(true) }
        end
      end
    end

    context "when subject is media_link" do
      let(:action) do
        {
          scope: current_scope,
          action: :create,
          subject: :media_link
        }
      end

      context "and scope is admin" do
        let(:current_scope) { :admin }

        context "when user is admin" do
          let(:user) { create :user, :admin, organization: organization }

          it { is_expected.to be(true) }
        end

        context "when user is not admin" do
          let(:user) { create :user, organization: organization }

          it { is_expected.not_to be(true) }
        end
      end
    end

    context "when subject is media_links" do
      let(:action) do
        {
          scope: :public,
          action: :list,
          subject: :media_links
        }
      end

      context "when user is admin" do
        let(:user) { create :user, :admin, organization: organization }

        it { is_expected.to be(true) }
      end

      context "when user is not admin" do
        let(:user) { create :user, organization: organization }

        it { is_expected.to be(true) }
      end
    end
  end
end
