Rails.logger.info "Starting decidim_govbr_user_proposals_statistic"

begin
  # Add link to export user statistics in Decidim Admin Menu
  Decidim.menu :admin_menu do |menu|
    menu.add_item :users_proposals_statistics,
    'Relatório de estatísticas de usuários Conf. da Juventude',
    '/admin/user_proposal_statistic_report/confjuv4',
    active: is_active_link?('user_proposal_statistics'),
    if: allowed_to?(:read, :admin_user),
    icon_name: 'envelope-closed',
    position: 4.6
  end
rescue
  # Ensure APP initializes even if this task breaks
end


Rails.logger.info "Finished decidim_govbr_user_proposals_statistic"