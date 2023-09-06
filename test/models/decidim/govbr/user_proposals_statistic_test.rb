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
    end
  end
end