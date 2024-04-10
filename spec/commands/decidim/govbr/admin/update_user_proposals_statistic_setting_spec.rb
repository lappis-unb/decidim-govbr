# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe UpdateUserProposalsStatisticSetting do
        subject { described_class.new(form, statistic_setting) }

        let!(:participatory_space) { create(:participatory_process) }
        let(:statistic_setting) { create :statistic_setting, participatory_space: participatory_space }
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
        let(:name) { "New User Proposals Statistic Report" }
        let(:proposals_done_weight) { statistic_setting.proposals_done_weight + 1 }
        let(:comments_done_weight) { statistic_setting.comments_done_weight + 1 }
        let(:votes_done_weight) { statistic_setting.votes_done_weight + 1 }
        let(:follows_done_weight) { statistic_setting.follows_done_weight + 1 }
        let(:votes_received_weight) { statistic_setting.votes_received_weight + 1 }
        let(:comments_received_weight) { statistic_setting.comments_received_weight + 1 }
        let(:follows_received_weight) { statistic_setting.follows_received_weight + 1 }
        let(:users_to_be_exported) { statistic_setting.users_to_be_exported + 1 }
        let(:form) do
          form_klass
            .from_params(form_params)
            .with_context(current_user: current_user, current_organization: participatory_space.organization)
        end

        context "when name is not given" do
          let(:name) { nil }

          it { expect { subject.call }.to broadcast(:invalid) }
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
          it { expect { subject.call }.to(change(statistic_setting, :name).from(statistic_setting.name).to(name)) }
          it { expect { subject.call }.to(change(statistic_setting, :proposals_done_weight).from(statistic_setting.proposals_done_weight).to(proposals_done_weight)) }
          it { expect { subject.call }.to(change(statistic_setting, :comments_done_weight).from(statistic_setting.comments_done_weight).to(comments_done_weight)) }
          it { expect { subject.call }.to(change(statistic_setting, :votes_done_weight).from(statistic_setting.votes_done_weight).to(votes_done_weight)) }
          it { expect { subject.call }.to(change(statistic_setting, :follows_done_weight).from(statistic_setting.follows_done_weight).to(follows_done_weight)) }
          it { expect { subject.call }.to(change(statistic_setting, :votes_received_weight).from(statistic_setting.votes_received_weight).to(votes_received_weight)) }
          it { expect { subject.call }.to(change(statistic_setting, :comments_received_weight).from(statistic_setting.comments_received_weight).to(comments_received_weight)) }
          it { expect { subject.call }.to(change(statistic_setting, :follows_received_weight).from(statistic_setting.follows_received_weight).to(follows_received_weight)) }
          it { expect { subject.call }.to(change(statistic_setting, :users_to_be_exported).from(statistic_setting.users_to_be_exported).to(users_to_be_exported)) }

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:update!)
              .with(statistic_setting, current_user, kind_of(Hash), hash_including(resource: hash_including(title: statistic_setting.name)))
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
