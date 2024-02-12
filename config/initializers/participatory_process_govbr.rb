Decidim::ParticipatoryProcesses::AdminEngine.class_eval do
  routes do
    resources :participatory_processes, param: :slug, only: [] do
      resources :partners, except: [:show]
      resources :media_links, except: [:show]
    end
  end
end

Decidim.menu :admin_participatory_process_menu do |menu|
  menu.add_item :participatory_process_partners,
                I18n.t("partners", scope: "decidim.admin.menu.assemblies_submenu"),
                main_app.participatory_process_partners_path(current_participatory_space),
                if: allowed_to?(:read, :partner, participatory_process: current_participatory_space),
                active: is_active_link?(main_app.participatory_process_partners_path(current_participatory_space)),
                position: 10

  menu.add_item :participatory_process_media_links,
                I18n.t("media_links", scope: "decidim.admin.menu.assemblies_submenu"),
                main_app.participatory_process_media_links_path(current_participatory_space),
                if: allowed_to?(:read, :media_link, participatory_process: current_participatory_space),
                active: is_active_link?(main_app.participatory_process_media_links_path(current_participatory_space))
end
