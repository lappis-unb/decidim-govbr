require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
                                              ::Digest::SHA256.hexdigest(ENV['ADMIN_USERNAME'])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
                                                ::Digest::SHA256.hexdigest(ENV['ADMIN_PASSWORD']))
end if Rails.env.production?

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  mount Decidim::Core::Engine => '/'

  get 'admin/user_proposal_statistic_report/:slug', to: 'decidim/govbr/user_proposals_statistic_settings#export_user_data', as: 'user_proposal_statistic_report'

  # These two routes are not present anywhere in the product
  # Instead, it's meant to be used by an advanced admin directly on URL
  # This is going to be removed once admin front-end is finished
  get 'admin/user_proposal_statistic_report_force_refresh/:slug', to: 'decidim/govbr/user_proposals_statistic_settings#force_refresh', as: 'user_proposal_statistic_report_force_refresh'
  get 'admin/user_proposal_statistic_report_create/:slug', to: 'decidim/govbr/user_proposals_statistic_settings#create', as: 'user_proposal_statistic_report_create'
end
