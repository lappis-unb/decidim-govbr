class ApplicationController < ActionController::Base
  DECIDIM_ADMIN_SCOPE = "decidim.admin".freeze
  DECIDIM_MEETINGS_SCOPE = "decidim.meetings".freeze
  DECIDIM_PROPOSALS_SCOPE = "decidim.proposals.admin".freeze
end
