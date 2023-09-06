begin
  # Add link to export user statistics in Decidim Admin Menu
  Decidim.menu :admin_menu do |menu|
    menu.add_item :users_proposals_statistics,
    'Relatório de estatísticas de usuários ENDG',
    '/admin/user_proposal_statistic_report/engd',
    active: is_active_link?('user_proposal_statistics'),
    if: allowed_to?(:read, :admin_user),
    icon_name: 'chat',
    position: 5
  end
rescue
  # Ensure APP initializes even if this task breaks
end