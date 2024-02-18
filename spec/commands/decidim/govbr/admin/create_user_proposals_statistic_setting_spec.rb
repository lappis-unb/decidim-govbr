# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe CreateUserProposalsStatisticSetting do
        subject { described_class.new(form, current_user, participatory_space) }

        let(:participatory_space) { create :participatory_process }
        let!(:current_user) { create :user, :confirmed, organization: participatory_space.organization }

        let(:form_klass) { Decidim::Govbr::Admin::UserProposalsStatisticSettingForm }
        let(:form_params) do
          {
            participatory_space_user_proposals_statistic_setting: form_attributes
          }
        end
        let(:form_attributes) do
          {
            name: name,
            proposals_done_weight: proposals_done_weight,
            comments_done_weight: comments_done_weight,
            votes_done_weight: votes_done_weight,
            follows_done_weight: follows_done_weight,
            votes_received_weight: votes_received_weight,
            comments_received_weight: comments_received_weight,
            follows_received_weight: follows_received_weight,
            users_to_be_exported: users_to_be_exported
          }
        end
        let(:name) { "User Proposals Statistic Report" }
        let(:proposals_done_weight) { ::Faker::Number.between(from: 1, to: 10) }
        let(:comments_done_weight) { ::Faker::Number.between(from: 1, to: 10) }
        let(:votes_done_weight) { ::Faker::Number.between(from: 1, to: 10) }
        let(:follows_done_weight) { ::Faker::Number.between(from: 1, to: 10) }
        let(:votes_received_weight) { ::Faker::Number.between(from: 1, to: 10) }
        let(:comments_received_weight) { ::Faker::Number.between(from: 1, to: 10) }
        let(:follows_received_weight) { ::Faker::Number.between(from: 1, to: 10) }
        let(:users_to_be_exported) { ::Faker::Number.between(from: 1, to: 10) }
        let(:form) do
          form_klass
            .from_params(form_params)
            .with_context(current_user: current_user, current_organization: participatory_space.organization)
        end

        context "when form is not valid" do
          let(:name) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when name is not given" do

        end

        context "when proposals_done_weight is not given" do
          let(:proposals_done_weight) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when comments_done_weight is not given" do
          let(:comments_done_weight) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when votes_done_weight is not given" do
          let(:votes_done_weight) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when follows_done_weight is not given" do
          let(:follows_done_weight) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when votes_received_weight is not given" do
          let(:votes_received_weight) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when comments_received_weight is not given" do
          let(:comments_received_weight) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when follows_received_weight is not given" do
          let(:follows_received_weight) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        context "when users_to_be_exported is not given" do
          let(:users_to_be_exported) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
        end

        shared_examples "when everything is ok" do
          let(:statistic_setting) { UserProposalsStatisticSetting.last }

          it "creates a statistic setting" do
            expect { subject.call }.to change(UserProposalsStatisticSetting, :count).by(1)
          end

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "sets the participatory space" do
            subject.call
            expect(statistic_setting.participatory_space).to eq participatory_space
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with(
                :create,
                UserProposalsStatisticSetting,
                current_user,
                hash_including(
                  resource: hash_including(title: name),
                  participatory_space: hash_including(title: participatory_space.title)
                )
              )
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
          end
        end

        context "when participatory space is participatory process," do
          let(:participatory_space) { create(:participatory_process) }
          include_examples "when everything is ok"
        end

        context "when participatory space is assembly," do
          let(:participatory_space) { create(:assembly) }
          include_examples "when everything is ok"
        end
      end
    end
  end
end