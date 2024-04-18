# frozen_string_literal: true

require "rails_helper"

module Decidim::Govbr
  describe UserProposalsStatistic do
    subject { UserProposalsStatistic }

    let(:organization) { create :organization }
    let(:participatory_space) { create :participatory_process, organization: organization }
    let(:statistic_setting) { create :statistic_setting, decidim_participatory_space: participatory_space }
    let(:statistic_one) { create :user_proposals_statistic, user: user_one, user_proposals_statistic_setting: statistic_setting }
    let(:statistic_two) { create :user_proposals_statistic, user: user_two, user_proposals_statistic_setting: statistic_setting }
    let(:user_one) { create :user, :confirmed, organization: organization }
    let(:user_two) { create :user, :confirmed, organization: organization }
    let(:statistics) { [statistic_one, statistic_two] }

    describe ".by_user" do
      subject { UserProposalsStatistic.by_user(target_user) }

      context "when statistic does not belong to user" do
        let(:target_user) { create :user, :confirmed, organization: organization }

        it "returns no statistic" do
          expect(subject).to be_empty
        end
      end

      context "when statistic belongs to user" do
        let(:target_user) { user_one }

        it "returns the associated statistics" do
          expect(subject).to contain_exactly(statistic_one)
        end
      end
    end

    describe ".by_component" do
      subject { UserProposalsStatistic.by_component(target_component) }

      context "when component does not belong to statistics participatory space" do
        let(:target_component) { create :proposal_component }

        it "returns no statistic" do
          expect(subject).to be_empty
        end
      end

      context "when component belongs to statistic participatory space" do
        let(:target_component) { create :proposal_component, participatory_space: participatory_space }

        it "returns the associated statistics" do
          expect(subject).to contain_exactly(*statistics)
        end
      end
    end

    describe ".csv_attributes_header_map" do
      subject { UserProposalsStatistic.csv_attributes_header_map }
      let(:columns) do
        UserProposalsStatistic.column_names - %w(id decidim_user_identification_number created_at updated_at user_proposals_statistic_setting_id)
      end

      it "translates all model columns" do
        expect(subject.keys).to match_array(columns)
      end

      it "provides no empty translations" do
        expect(subject.values).to all be_present
      end
    end
  end
end