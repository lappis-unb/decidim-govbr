# Push initial user proposals statistic setting to the database
Decidim::Govbr::UserProposalsStatisticSetting.upsert(
  # TODO: insert data to initial row
)

# Add link to export user statistics in Decidim Admin Menu
Decidim.menu :admin_user_menu do |menu|
  menu.add_item :export_users_statistic,
                'Relatório de estatísticas de usuários',
                'user_proposal_statistic',
                active: is_active_link?('user_proposal_statistic'),
                if: allowed_to?(:read, :admin_user)
end