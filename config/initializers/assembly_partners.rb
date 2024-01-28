Decidim::Assemblies::AdminEngine.class_eval do
  routes do
    resources :assemblies, param: :slug, only: [] do
      resources :partners, except: [:show]
    end
  end
end

Decidim.menu :admin_assembly_menu do |menu|
  menu.add_item :assembly_partners,
                I18n.t("partners", scope: "decidim.admin.menu.assemblies_submenu"),
                assembly_partners_path(current_participatory_space),
                if: allowed_to?(:read, :partner, assembly: current_participatory_space),
                active: is_active_link?(assembly_partners_path(current_participatory_space)),
                position: 10
end