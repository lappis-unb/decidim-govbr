# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# You can remove the 'faker' gem if you don't want Decidim seeds.
# Decidim.seed!

# Cria o administrador do sistema
Decidim::System::Admin.new(email: ENV['SYS_ADMIN_EMAIL'], password: ENV['SYS_ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD']).save!(validate: false)

# Define cores padrões do Brasil Participativo
colors = {
    primary: '#1351b4',
    secondary: '#2378c3',
    success: '#168821',
    warning: '#2670e8',
    alert: '#e5220a',
    highlight: '#be6400',
    theme: '#1351b4'
}

# Snippets do Cabeçalho
header_snippets_file = URI.open(ENV['CUSTOMIZED_CODE_SNIPPET_URL'])
header_snippets_io = StringIO.new(header_snippets_file.read)
header_snippets = header_snippets_io.read
puts 'Header Snippet criado com sucesso.'

# main_menu_file = URI.open(ENV['CUSTOMIZED_MAIN_MENU_URL'])
# main_menu_io = StringIO.new(main_menu_file.read)
# main_menu = main_menu_io.read
puts 'Menu links importados com sucesso.'

# Cria a organização Brasil Participativo
organization_name = ENV['ORG_NAME']
organization = Decidim::Organization.find_by(name: organization_name)
if !organization
    organization = Decidim::Organization.create!(
        name: organization_name,
        host: 'localhost',
        default_locale: 'pt-BR',
        available_locales: ['en', 'pt-BR'],
        reference_prefix: ENV['ORG_NAME_PREFIX'],
        available_authorizations: Decidim.authorization_workflows.map(&:name),
        users_registration_mode: :enabled,
        tos_version: Time.current,
        badges_enabled: true,
        user_groups_enabled: true,
        send_welcome_notification: true,
        file_upload_settings: Decidim::OrganizationSettings.default(:upload),
        external_domain_whitelist: ['decidim.org', 'github.com'],
        colors: colors,
        header_snippets: header_snippets,
        #menu_links: main_menu,
    )
    organization.save!
    puts 'Organização #{my_variable} criada'

end

# Cria um admin e relaciona com a organização 
admin = Decidim::User.find_or_initialize_by(email: ENV['ORG_ADMIN_EMAIL'])
puts 'Usuário com o e-mail' + ENV['ORG_ADMIN_EMAIL'] + 'criado ou encontrado.'

admin_hash = {
    name: ENV['ORG_ADMIN_NAME'],
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
    admin_terms_accepted_at: Time.current,
}

admin_hash.merge!(password: ENV['ORG_ADMIN_PASSWORD']) if admin.encrypted_password.blank?
admin.update!(admin_hash)
puts 'Processo de administrador do sistema concluído com sucesso.'

# Cria Blocos de Conteúdo ativo da organização
home_arquivo = URI.open(ENV['CUSTOMIZED_CODE_HTML_HOME_PAGE_URL'])
home_snippets = File.read(home_arquivo)
puts 'Home Snippet criado com sucesso.'

content_block = Decidim::ContentBlock.find_by(manifest_name: 'html')
content_block = Decidim::ContentBlock.create!(
    id: 1, 
    decidim_organization_id: 1,
    manifest_name: 'html',
    scope_name: 'homepage',
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
puts 'Bloco "Bloco HTML" ativo.'

# Snippets da home page
html_content_block = Decidim::ContentBlock.find_by(organization: organization, manifest_name: :html, scope_name: :homepage)
html_content_block.save!

# bp_arquivo = Rails.root.join(__dir__, 'seeds', 'bp_components.json') 
# bp_components = File.read(bp_arquivo)

# Adicionando processos
# processes = Decidim::ParticipatoryProcess.create!(
#     id: 1,
#     slug: 'brasilparticipativo',
#     hashtag: '',
#     decidim_organization_id: 1,
#     created_at: Time.current,
#     updated_at: Time.current,
#     title: {
#         'pt-BR': 'Brasil Participativo'
#     },
#     subtitle: {
#         'pt-BR': 'Presidencia'
#     },
#     short_description: {
#         'pt-BR': '<p>brasil participativo</p>'
#     },
#     description: {
#         'pt-BR': '<p>brasil participativo</p>'
#     },
#     hero_image: nil,
#     banner_image: nil,
#     published_at: nil,
#     developer_group: {
#         'pt-BR': ''
#     },
#     end_date: nil,
#     meta_scope: {
#         'pt-BR': ''
#     },
#     local_area: {
#         'pt-BR': ''
#     },
#     target: {
#         'pt-BR': ''
#     },
#     participatory_scope: {
#         'pt-BR': ''
#     },
#     participatory_structure: {
#         'pt-BR': ''
#     },
#     decidim_scope_id: nil,
#     decidim_participatory_process_group_id: 7,
#     show_statistics: true,
#     announcement: {
#         'pt-BR': ''
#     },
#     start_date: nil,
#     decidim_area_id: nil,
#     decidim_scope_type_id: nil,
#     weight: 1,
#     follows_count: 1,
#     private_space: false,
#     promoted: false,
#     scopes_enabled: false,
#     show_metrics: false,
#     show_statistics: false,
# )
# processes.save!

# processes = Decidim::ParticipatoryProcess.create!(
#     id: 2,
#     slug: 'programas',
#     hashtag: '',
#     decidim_organization_id: 1,
#     created_at: Time.current,
#     updated_at: Time.current,
#     title: {
#         'pt-BR': 'PPA Participativo'
#     },
#     subtitle: {
#         'pt-BR': 'Escolha seus programas prioritários e Envie propostas'
#     },
#     short_description: {
#         'pt-BR': '<p>Neste processo as pessoas vão poder votar em até 3 programas prioritários que levarão ações estruturantes para os seus territórios. Além de poderem enviar uma proposta de implementação de política pública para sua região ou município. </p>'
#     },
#     description: {
#         'pt-BR': '<p>Após escolher os três programas estruturantes de sua preferência clique na aba lateral <strong>\"Envie uma proposta para o PPA\"</strong> para enviar uma proposta para o PPA 2023.</p>'
#     },
#     hero_image: nil,
#     banner_image: nil,
#     published_at: nil,
#     developer_group: {
#         'pt-BR': ''
#     },
#     end_date: nil,
#     meta_scope: {
#         'pt-BR': ''
#     },
#     local_area: {
#         'pt-BR': ''
#     },
#     target: {
#         'pt-BR': ''
#     },
#     participatory_scope: {
#         'pt-BR': ''
#     },
#     participatory_structure: {
#         'pt-BR': ''
#     },
#     decidim_scope_id: nil,
#     decidim_participatory_process_group_id: 7,
#     show_statistics: true,
#     announcement: {
#         'pt-BR': ''
#     },
#     start_date: nil,
#     decidim_area_id: nil,
#     decidim_scope_type_id: nil,
#     weight: 1,
#     follows_count: 1,
#     private_space: false,
#     promoted: false,
#     scopes_enabled: false,
#     show_metrics: true,
#     show_statistics: true,
# )
# processes.save!

# component = Decidim::Component.create!(
#     id: 1,
#     manifest_name: 'blogs',
#     name: {
#         'pt-BR': 'Notícias'
#     },
#     participatory_space_id: 1,
#     settings: {
#         steps: {},
#         global: {
#             announcement: {
#                 'pt-BR': ''
#             },
#             announcement_en: nil,
#             comments_enabled: false,
#             announcement_pt__BR: '',
#             comments_max_length: 0
#         },
#         default_step: {
#             announcement: {
#                 'pt-BR': ''
#             },
#             announcement_en: nil,
#             comments_blocked: false,
#             announcement_pt__BR: nil,
#             endorsements_blocked: false,
#             endorsements_enabled: true
#         }
#     },
#     weight: 0,
#     permissions: nil,
#     published_at: Time.current,
#     created_at: Time.current,
#     updated_at: Time.current,
#     participatory_space_type: Decidim::ParticipatoryProcess,
# )
# component.save!

# component = Decidim::Component.create!(
#     id: 2,
#     manifest_name: 'pages',
#     name: {
#         'pt-BR': 'Início'
#     },
#     participatory_space_id: 1,
#     settings: {
#         steps: {},
#         global: {
#             announcement: {
#                 'pt-BR': ''
#             },
#             announcement_en: nil,
#             comments_enabled: false,
#             announcement_pt__BR: '',
#             comments_max_length: 0
#         },
#         default_step: {
#             announcement: {
#                 'pt-BR': ''
#             },
#             announcement_en: nil,
#             comments_blocked: false,
#             announcement_pt__BR: nil,
#             endorsements_blocked: false,
#             endorsements_enabled: true
#         }
#     },
#     weight: 0,
#     permissions: nil,
#     published_at: Time.current,
#     created_at: Time.current,
#     updated_at: Time.current,
#     participatory_space_type: Decidim::ParticipatoryProcess,
# )
# component.save!

# Decidim::Pages::Page.create()

# Cria processos ---------------------------------------------------------------
bp_process = Decidim::ParticipatoryProcess.create!(
    id: 2,
    slug: 'brasilparticipativo',
    decidim_organization_id: 1,
    title: {
        'pt-BR': 'Brasil Participativo'
    },
    subtitle: {
        'pt-BR': 'Presidencia'
    },
    short_description: {
        'pt-BR': '<p>brasil participativo</p>'
    },
    description: {
        'pt-BR': '<p>brasil participativo</p>'
    }
)
bp_process.save!

ppa_process = Decidim::ParticipatoryProcess.create!(
    id: 1,
    slug: 'programas',
    decidim_organization_id: 1,
    title: {
        'pt-BR': 'PPA Participativo'
    },
    subtitle: {
        'pt-BR': 'Escolha seus programas prioritários e Envie propostas'
    },
    short_description: {
        'pt-BR': '<p>Neste processo as pessoas vão poder votar em até 3 programas prioritários que levarão ações estruturantes para os seus territórios. Além de poderem enviar uma proposta de implementação de política pública para sua região ou município. </p>'
    },
    description: {
        'pt-BR': '<p>Após escolher os três programas estruturantes de sua preferência clique na aba lateral <strong>\"Envie uma proposta para o PPA\"</strong> para enviar uma proposta para o PPA 2023.</p>'
    },
)
ppa_process.save!

# Cria componentes -------------------------------------------------------------
component = Decidim::Component.create!(
    id: 1,
    manifest_name: 'blogs',
    name: {
        'pt-BR': 'Notícias'
    },
    participatory_space_id: 2,
    participatory_space_type: Decidim::ParticipatoryProcess,
)
component.save!

# Cria steps ---------------------------------------------------------------
process_step = Decidim::ParticipatoryProcessStep.create!(
    decidim_participatory_process_id: 1,
    id: 7,
    title: {
        'pt-BR': 'Introdução'
    },
    description: nil,
    start_date: nil,
    end_date: nil,
    cta_path: nil,
    cta_text: {
    },
    active: true,
    position: 0
)
process_step.save!

process_step = Decidim::ParticipatoryProcessStep.create!(
    decidim_participatory_process_id: 2,
    id: 8,
    title: {
        'pt-BR': 'Introdução'
    },
    description: nil,
    start_date: nil,
    end_date: nil,
    cta_path: nil,
    cta_text: {
    },
    active: true,
    position: 0
)
process_step.save!

# ---------------------------------------------------- Criar componentes iterando o JSON
# require 'json'

# path = Rails.root.join(__dir__, 'seeds', 'a.json')
# json_data = File.read(path)
# data = JSON.parse(json_data)

# components = data['components']

# components.each do |component_data|
#   Decidim::Component.new(component_data).save!
# end
