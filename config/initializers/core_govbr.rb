Decidim::Core::Engine.class_eval do
  routes do
    resource(:registration, only: [], as: :user_registration, path: "/users", controller: "devise/registrations") do
      get :pending_confirmation
    end
  end
end
