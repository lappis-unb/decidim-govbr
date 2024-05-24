# config/initializers/some_initializer.rb
Rails.logger.info "Starting assembly_govbr"

Decidim::Assemblies::AdminEngine.class_eval do
  routes do
    resources :assemblies, param: :slug, only: [] do
      resources :partners, except: [:show]
      resources :media_links, except: [:show]
    end
  end
end

Decidim::Assemblies::Engine.class_eval do
  routes do
    resources :assemblies, param: :slug, only: [] do
      resources :media, only: :index
    end
  end
end

Decidim.menu :admin_assembly_menu do |menu|
  menu.add_item :assembly_partners,
                I18n.t("partners", scope: "decidim.admin.menu.assemblies_submenu"),
                main_app.assembly_partners_path(current_participatory_space),
                if: allowed_to?(:read, :partner, assembly: current_participatory_space),
                active: is_active_link?(main_app.assembly_partners_path(current_participatory_space)),
                position: 10

  menu.add_item :assembly_media_links,
                I18n.t("media_links", scope: "decidim.admin.menu.assemblies_submenu"),
                main_app.assembly_media_links_path(current_participatory_space),
                if: allowed_to?(:read, :media_link, assembly: current_participatory_space),
                active: is_active_link?(main_app.assembly_media_links_path(current_participatory_space)),
                position: 6
end

Rails.logger.info "Finished assembly_govbr"