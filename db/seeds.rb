colors = {
    primary: "#1351b4",
    secondary: "#2378c3",
    success: "#168821",
    warning: "#2670e8",
    alert: "#e5220a",
    highlight: "#be6400",
    theme: "#1351b4"
}

# Cria a organização Brasil Participativo
organization = Decidim::Organization.find_by(name: 'Brasil Participativo')

if !organization
    organization = Decidim::Organization.create!(
        name: 'Brasil Participativo',
        host: 'localhost',
        default_locale: 'pt',
        available_locales: ['en', 'pt'],
        reference_prefix: 'brasil_participativo',
        available_authorizations: Decidim.authorization_workflows.map(&:name),
        users_registration_mode: :enabled,
        tos_version: Time.current,
        badges_enabled: true,
        user_groups_enabled: true,
        send_welcome_notification: true,
        file_upload_settings: Decidim::OrganizationSettings.default(:upload),
        external_domain_whitelist: ["decidim.org", "github.com"],
        colors: colors,
    )
    brasil_participativo.save!
    puts "Organização 'Brasil Participativo' criada."
# else
#     organization.update!(
#         {
#             colors: colors,
#             default_locale: 'pt-BR',
#             available_locales: ['en', 'pt-BR']
#         }
#     )
end

# Cria um admin e relaciona com a organização 
admin = Decidim::User.find_or_initialize_by(email: 'brasil@participativo.com')
puts "Usuário com o e-mail brasil@participativo criado ou encontrado."

admin_hash = {
    name: 'Admin Brasil Participativo',
    nickname: 'admin_bp',
    organization: organization,
    confirmed_at: Time.current,
    locale: 'pt-BR',
    admin: true,
    tos_agreement: true,
    about: 'Admin do decidim',
    accepted_tos_version: organization.tos_version + 1.hour,
    newsletter_notifications_at: Time.current,
    password_updated_at: Time.current,
    admin_terms_accepted_at: Time.current
}
admin.update!(admin_hash)
admin.password = 'admin'
admin.password_confirmation = 'admin'
admin.save!(validate: false)