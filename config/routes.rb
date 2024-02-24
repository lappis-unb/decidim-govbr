# frozen_string_literal: true

require 'sidekiq/web'

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
                                                ::Digest::SHA256.hexdigest(ENV['ADMIN_USERNAME'])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
                                                  ::Digest::SHA256.hexdigest(ENV['ADMIN_PASSWORD']))
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  mount Decidim::Core::Engine => '/'

  get 'admin/user_proposal_statistic_report/:slug',
      to: 'decidim/govbr/user_proposals_statistic_settings#export_user_data', as: 'user_proposal_statistic_report'

  # These two routes are not present anywhere in the product
  # Instead, it's meant to be used by an advanced admin directly on URL
  # This is going to be removed once admin front-end is finished
  get(
    'admin/user_proposal_statistic_report_force_refresh/:slug',
    to: 'decidim/govbr/user_proposals_statistic_settings#force_refresh',
    as: 'user_proposal_statistic_report_force_refresh'
  )
  get(
    'admin/user_proposal_statistic_report_create/:slug',
    to: 'decidim/govbr/user_proposals_statistic_settings#create',
    as: 'user_proposal_statistic_report_create'
  )

  post(
    'admin/organization/homepage/edit',
    to: 'decidim/admin/organization_homepage#add_html_block',
    as: 'add_html_block')

  resources :assemblies, param: :slug, only: [] do
    resources :media, only: :index, controller: 'decidim/assemblies/media'
  end

  resources :participatory_processes, param: :slug, only: [], path: :processes do
    resources :media, only: :index, controller: 'decidim/participatory_processes/media'
  end

  scope :admin do
    resources :assemblies, param: :slug, only: [] do
      resources :partners, except: [:show], controller: 'decidim/assemblies/admin/partners'
      resources :media_links, except: [:show], controller: 'decidim/assemblies/admin/media_links'
    end
  end

  scope :admin do
    resources :participatory_processes, param: :slug, only: [] do
      resources :partners, except: [:show], controller: 'decidim/participatory_processes/admin/partners'
      resources :media_links, except: [:show], controller: 'decidim/participatory_processes/admin/media_links'
    end
  end
end
