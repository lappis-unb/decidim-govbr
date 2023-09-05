# Add link to export user statistics in Decidim Admin Menu
Decidim.menu :admin_user_menu do |menu|
  menu.add_item :export_users_statistic,
                'Relatório de estatísticas de usuários',
                'admin/user_proposal_statistics',
                active: is_active_link?('user_proposal_statistic'),
                if: allowed_to?(:read, :admin_user)
end

# Add link to export user statistics in Decidim Admin Menu
Decidim.menu :admin_menu do |menu|
  menu.add_item :users_proposals_statistics,
                'Relatório de estatísticas de usuários',
                'admin/user_proposal_statistics',
                active: is_active_link?('user_proposal_statistics'),
                if: allowed_to?(:read, :admin_user),
                icon_name: 'chat',
                position: 5
end