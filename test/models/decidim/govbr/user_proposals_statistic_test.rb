require 'test_helper'

module Decidim
  module Govbr
    class UserProposalsStatisticTest < ActiveSupport::TestCase
      test 'should translate only existent attributes' do
        setting = Decidim::Govbr::UserProposalsStatisticSetting.create!(decidim_participatory_space_type: 'foo', decidim_participatory_space_id: 1)
        statistic = Decidim::Govbr::UserProposalsStatistic.create!(user_proposals_statistic_setting: setting, decidim_user_id: 1, decidim_user_name: "User 1", decidim_user_identification_number: "CPF")

        Decidim::Govbr::UserProposalsStatistic.csv_attributes_header_map.each do |attribute, translation|
          assert statistic.respond_to?(attribute)
          refute_empty translation
        end
      end

      test 'should return on by_component only statistics realated to the specified component and user' do
        setting1 = Decidim::Govbr::UserProposalsStatisticSetting.create!(decidim_participatory_space_type: 'foo', decidim_participatory_space_id: 1, name: 'setting from foo 1')
        setting2 = Decidim::Govbr::UserProposalsStatisticSetting.create!(decidim_participatory_space_type: 'foo', decidim_participatory_space_id: 1, name: 'setting from foo 2')
        setting3 = Decidim::Govbr::UserProposalsStatisticSetting.create!(decidim_participatory_space_type: 'bar', decidim_participatory_space_id: 1, name: 'setting from bar')

        statistic1 = Decidim::Govbr::UserProposalsStatistic.create!(user_proposals_statistic_setting: setting1, decidim_user_id: 1, decidim_user_name: "User 1", decidim_user_identification_number: "CPF")
        statistic2 = Decidim::Govbr::UserProposalsStatistic.create!(user_proposals_statistic_setting: setting2, decidim_user_id: 2, decidim_user_name: "User 1", decidim_user_identification_number: "CPF")
        statistic3 = Decidim::Govbr::UserProposalsStatistic.create!(user_proposals_statistic_setting: setting3, decidim_user_id: 3, decidim_user_name: "User 1", decidim_user_identification_number: "CPF")
        statistic4 = Decidim::Govbr::UserProposalsStatistic.create!(user_proposals_statistic_setting: setting3, decidim_user_id: 3, decidim_user_name: "User 1", decidim_user_identification_number: "CPF")

        component1 = Decidim::Component.new(participatory_space_type: 'foo', participatory_space_id: 1)
        component2 = Decidim::Component.new(participatory_space_type: 'bar', participatory_space_id: 1)

        assert_equal [statistic1, statistic2].sort, Decidim::Govbr::UserProposalsStatistic.by_component(component1).to_a.sort
        assert_equal [statistic3, statistic4].sort, Decidim::Govbr::UserProposalsStatistic.by_component(component2).to_a.sort

        user1 = Decidim::User.new(id: 1)
        user3 = Decidim::User.new(id: 3)

        assert_equal [statistic1], Decidim::Govbr::UserProposalsStatistic.by_user(user1).to_a.sort
        assert_equal [statistic3, statistic4], Decidim::Govbr::UserProposalsStatistic.by_user(user3).to_a.sort

        assert_equal [statistic3, statistic4], Decidim::Govbr::UserProposalsStatistic.by_component(component2).by_user(user3).to_a.sort
        assert_equal [statistic1], Decidim::Govbr::UserProposalsStatistic.by_component(component1).by_user(user1).to_a.sort
      end
    end
  end
end