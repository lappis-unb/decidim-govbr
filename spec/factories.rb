# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/participatory_processes/test/factories"
require "decidim/assemblies/test/factories"
require "decidim/proposals/test/factories"
require "decidim/comments/test/factories"
require "decidim/accountability/test/factories"
require "decidim/meetings/test/factories"

FactoryBot.define do
  factory :partner, class: "Decidim::Govbr::Partner" do
    name { "partner" }
    weight { 1 }

    trait :as_organizer do
      partner_type { "organizer" }
    end

    trait :as_supporter do
      partner_type { "supporter" }
    end
  end

  factory :govbr_media_link, class: "Decidim::Govbr::MediaLink" do
    title { generate_localized_title }
    weight { Faker::Number.between(from: 1, to: 10) }
    link { Faker::Internet.url }
    date { 1.month.ago }
  end
end
