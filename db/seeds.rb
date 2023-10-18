# Define cores padrões do Brasil Participativo
colors = {
    primary: "#1351b4",
    secondary: "#2378c3",
    success: "#168821",
    warning: "#2670e8",
    alert: "#e5220a",
    highlight: "#be6400",
    theme: "#1351b4"
}

# Snippets do Cabeçalho

arquivo = Rails.root.join(__dir__, 'seeds', 'snippet.html')
header_snippets = File.read(arquivo)
puts "Header Snnipet criado com sucesso"

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
        header_snippets: header_snippets,
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

admin_hash.merge!(password: "decidim123456789") if admin.encrypted_password.blank?
admin.update!(admin_hash)
puts "Processo de administrador do sistema concluído com sucesso"

# Criando Blocos de Conteúdo ativo da organização

# Decidim::System::CreateDefaultContentBlocks.call(organization)
home_arquivo = Rails.root.join(__dir__, 'seeds', 'home-page.html') 
home_snippets = File.read(home_arquivo)
puts "Home Snnipet criado com sucesso"

# Cria a organização Brasil Participativo
content_block = Decidim::ContentBlock.find_by(manifest_name: "html")

content_block = Decidim::ContentBlock.create!(
    id: 1, 
    decidim_organization_id: 1,
    manifest_name: "html",
    scope_name: "homepage",
    settings: { 
        html_content_pt: home_snippets,
    },
    published_at: Time.current,
    weight: 1,
    images: {},
    scoped_resource_id: nil,
    created_at: Time.current,
    updated_at: Time.current   
)
    content_block.save!
    puts "Bloco 'Bloco HTML' ativo"

html_content_block = Decidim::ContentBlock.find_by(organization: organization, manifest_name: :html, scope_name: :homepage)

# Snippets da home page

html_content_block.save!

# Adicionando processos

