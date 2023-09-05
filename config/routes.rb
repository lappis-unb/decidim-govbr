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

  root 'user_proposals_statistic_settings#index'

  get 'admin/user_proposal_statistic_report', to: 'decidim/govbr/user_proposals_statistic_settings#export_user_data'
  get 'admin/user_proposal_statistics', to: 'decidim/govbr/user_proposals_statistic_settings#index'
  get 'admin/user_proposal_statistic/new', to: 'decidim/govbr/user_proposals_statistic_settings#new'
end
