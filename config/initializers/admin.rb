# frozen_string_literal: true

Decidim::Admin::Engine.class_eval do
  routes do
    constraints(->(request) { Decidim::Admin::OrganizationDashboardConstraint.new(request).matches? }) do
      resources :officializations, only: [], param: :user_id do
        member do
          delete :delete_user
        end
      end
    end
  end
end
