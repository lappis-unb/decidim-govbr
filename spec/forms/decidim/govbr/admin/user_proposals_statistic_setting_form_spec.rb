# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe UserProposalsStatisticSettingForm do
        subject { described_class.from_params(attributes).with_context(current_user: current_user, current_organization: participatory_space.organization) }

        let(:participatory_space) { create :participatory_process }
        let!(:current_user) { create :user, :confirmed, organization: participatory_space.organization }

        let(:attributes) do
          {
            participatory_space_user_proposals_statistic_setting: {
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

        context "when everything is ok" do
          it { expect(subject).to be_valid }
        end

        context "when name is not given" do
          let(:name) { nil }

          it { expect(subject).not_to be_valid }
        end

        context "when proposals_done_weight is not given" do
          let(:proposals_done_weight) { nil }

          it { expect(subject).not_to be_valid }
        end

        context "when comments_done_weight is not given" do
          let(:comments_done_weight) { nil }

          it { expect(subject).not_to be_valid }
        end

        context "when votes_done_weight is not given" do
          let(:votes_done_weight) { nil }

          it { expect(subject).not_to be_valid }
        end

        context "when follows_done_weight is not given" do
          let(:follows_done_weight) { nil }

          it { expect(subject).not_to be_valid }
        end

        context "when votes_received_weight is not given" do
          let(:votes_received_weight) { nil }

          it { expect(subject).not_to be_valid }
        end

        context "when comments_received_weight is not given" do
          let(:comments_received_weight) { nil }

          it { expect(subject).not_to be_valid }
        end

        context "when follows_received_weight is not given" do
          let(:follows_received_weight) { nil }

          it { expect(subject).not_to be_valid }
        end

        context "when users_to_be_exported is not given" do
          let(:users_to_be_exported) { nil }

          it { expect(subject).not_to be_valid }
        end
      end
    end
  end
end