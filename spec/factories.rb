require "decidim/core/test/factories"

FactoryBot.define do
  factory :user_proposals_statistic, class: 'Decidim::Govbr::UserProposalsStatistic' do
    decidim_user_id { 1 }
    decidim_user_identification_number { '1234567890' }
    decidim_user_name { 'user' }
    proposals_done { 1 }
    comments_done { 2 }
    votes_done { 3 }
    follows_done { 4 }
    votes_received { 5 }
    comments_received { 6 }
    follows_received { 7 }
    score { 8 }
    user_proposals_statistic_setting
  end

  factory :user_proposals_statistic_setting, class: 'Decidim::Govbr::UserProposalsStatisticSetting' do
    name { 'Setting' }
    decidim_participatory_space_type { 'Decidim::Assembly' }
    decidim_participatory_space_id { 1 }

    trait :with_5_statistics do
      user_proposals_statistics {
        build_list(:user_proposals_statistic, 5) do |statistic, index|
          decidim_user_name = "User #{index}"
          decidim_user_id = index
        end
      }
    end
  end
end
