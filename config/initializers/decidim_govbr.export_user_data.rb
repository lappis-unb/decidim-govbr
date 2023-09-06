begin
  Decidim.menu :admin_user_menu do |menu|
    menu.add_item :users,
    'Exportar Relatório Geral de Usuários',
    '/admin/govbr/export_users_basic_information',
    active: false,
    if: allowed_to?(:read, :admin_user)
  end
rescue
  # Ensure APP initializes even if this task breaks
end