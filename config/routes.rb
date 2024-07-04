# frozen_string_literal: true

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

  resource :organization, only: [], controller: "decidim/admin/organization" do
    member do
      patch :autofill_menu_links, action: :autofill_menu_links
      patch :autofill_footer_menu_links, action: :autofill_footer_menu_links
    end
  end

  get 'admin/user_proposal_statistic_report/:slug', to: 'decidim/govbr/user_proposals_statistic_settings#export_user_data', as: 'user_proposal_statistic_report'

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

  resources :reports, only: [:create], controller: 'decidim/reports/reports'

  patch '/update_status_comment/:id/', to: 'decidim/comments/comments#update_status', as: 'update_comment_status'

  resources :assemblies, param: :slug, only: [] do
    resources :media, only: :index, controller: 'decidim/assemblies/media'
  end

  resources :meetings do
    member do
      delete :destroy
    end
  end

  resources :assemblies do
    member do
      delete :destroy
    end
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

  Decidim::Admin::Engine.routes.draw do
    constraints(->(request) { Decidim::Admin::OrganizationDashboardConstraint.new(request).matches? }) do
      resource :organization, only: [:edit, :update], controller: "organization" do
        resource :appearance, only: [:edit, :update], controller: "organization_appearance"
        resource :homepage, only: [:edit, :update], controller: "organization_homepage" do
          resources :content_blocks, only: [:edit, :update, :destroy, :create], controller: "organization_homepage_content_blocks"
        end
        resource :external_domain_whitelist, only: [:edit, :update], controller: "organization_external_domain_whitelist"
  
        member do
          get :users
          get :user_entities
        end
      end
    end
  end

  Decidim.participatory_space_manifests.each do |manifest|
    mount manifest.context(:admin).engine, at: "/", as: "decidim_admin_#{manifest.name}"
  end

  Decidim.authorization_admin_engines.each do |manifest|
    mount manifest.admin_engine, at: "/#{manifest.name}", as: "decidim_admin_#{manifest.name}"
  end


  scope :admin do
    resources :participatory_processes, param: :slug, only: [] do
      resources :partners, except: [:show], controller: 'decidim/participatory_processes/admin/partners'
      resources :media_links, except: [:show], controller: 'decidim/participatory_processes/admin/media_links'
      resources :user_proposals_statistic_settings, except: [:show], controller: 'decidim/participatory_processes/admin/user_proposals_statistic_settings' do
        member do
          get :export
          get :force_refresh
        end
      end
    end

    resources :participatory_process_groups, only: [] do
      resources :participatory_process_group_users,
                controller: 'decidim/participatory_processes/admin/participatory_process_group_users',
                except: [:show],
                as: :users
    end
  end
end

