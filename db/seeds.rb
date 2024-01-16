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
email = ENV['SYS_ADMIN_EMAIL']
password = ENV['SYS_ADMIN_PASSWORD']

if !email
    email = 'bpadmin@example.com'
    puts "Não foi encontrada a variável de ambiente $ADMIN_EMAIL, usuário criado com e-mail padrão 'bpadmin@example.com'"
end

if !password
    password = 'bpadmin123'
    puts "Não foi encontrada a variável de ambiente $ADMIN_PASSWORD, usuário criado com senha padrão 'bpadmin123'"
end

if !Decidim::System::Admin.find_by(email: email)
    Decidim::System::Admin.new(email: email, password: password, password_confirmation: password).save!(validate: false)
    puts "Usuário sysadmin criado com as credenciais:" 
    puts "Email: "+ email 
    puts "Senha: " + password
end

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
#arquivo = Rails.root.join(__dir__, 'seeds', 'snippet.html')
#header_snippets = File.read(arquivo)
puts 'Header Snippet criado com sucesso.'

main_menu_file = URI.open(ENV['CUSTOMIZED_MAIN_MENU_URL'])
main_menu_io = StringIO.new(main_menu_file.read)
main_menu = main_menu_io.read
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
        # menu_links: main_menu,
    )
    organization.save!
    puts 'Organização ' + organization_name + ' criada com sucesso.'
end

# Cria um admin e relaciona com a organização 
organization_admin_name = ENV['ORG_ADMIN_NAME']
organization_admin_email = ENV['ORG_ADMIN_EMAIL']
organizarion_admin_password = ENV['ORG_ADMIN_PASSWORD']

admin = Decidim::User.find_or_initialize_by(email: organization_admin_email)
puts "Usuário com o e-mail " + organization_admin_email + " criado ou encontrado."

admin_hash = {
    name: organization_admin_name,
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

admin_hash.merge!(password: organizarion_admin_password) if admin.encrypted_password.blank?
admin.update!(admin_hash)
puts 'Processo de administrador do sistema concluído com sucesso.'

# Cria Blocos de Conteúdo ativo da organização
home_arquivo = Rails.root.join(__dir__, 'seeds', 'home-page.html') 
home_snippets = File.read(home_arquivo)

content_block = Decidim::ContentBlock.find_by(manifest_name: 'html')
if !content_block
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
end

# Adicionando processos

file = File.open(Rails.root.join('db', 'seeds', 'process_ppa.json'))
blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: 'process_ppa.json')

class DummyImporter
    include Decidim::FormFactory
    def current_organization
        Decidim::Organization.first
    end

    def current_user
        Decidim::User.first
    end
end

hash_to_import = {"participatory_process"=>{"title_pt"=>"PPA Participativo", "title_pt__BR" => "PPA", "slug"=>"programas", "document"=>blob, "document_validation"=>"1", "import_steps"=>"1", "import_categories"=>"1", "import_attachments"=>"0", "import_components"=>"1", 'current_organization' => Decidim::Organization.first, 'organization_id' => 1, 'organization' => Decidim::Organization.first}}
form = DummyImporter.new.form(Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessImportForm).from_params(hash_to_import)

Decidim::ParticipatoryProcesses::Admin::ImportParticipatoryProcess.call(form) do
    on(:ok) do
        puts 'Processo "PPA Participativo" importado com sucesso.'
    end
    on(:invalid) do
        puts 'Ocorreu um erro ao importar o processo "PPA Participativo".'
    end
end

file2 = File.open(Rails.root.join('db', 'seeds', 'process_bp.json'))
blob2 = ActiveStorage::Blob.create_and_upload!(io: file2, filename: 'process_bp.json')

class DummyImporter
    include Decidim::FormFactory
    def current_organization
        Decidim::Organization.first
    end

    def current_user
        Decidim::User.first
    end
end

hash_to_import = {"participatory_process"=>{"title_pt__BR" => "Brasil Participativo", "slug"=>"brasilparticipativo", "document"=>blob2, "document_validation"=>"1", "import_steps"=>"1", "import_categories"=>"1", "import_attachments"=>"0", "import_components"=>"1", 'current_organization' => Decidim::Organization.first, 'organization_id' => 1, 'organization' => Decidim::Organization.first}}
form = DummyImporter.new.form(Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessImportForm).from_params(hash_to_import)

Decidim::ParticipatoryProcesses::Admin::ImportParticipatoryProcess.call(form) do
    on(:ok) do
        puts 'Processo "Brasil Participativo" importado com sucesso.'
    end
    on(:invalid) do
        puts 'Ocorreu um erro ao importar o processo "Brasil Participativo".'
    end
end

# Importando as assembleias

file3 = File.open(Rails.root.join('db', 'seeds', 'assemblies-confjuv4.json'))
blob3 = ActiveStorage::Blob.create_and_upload!(io: file3, filename: 'assemblies-confjuv4.json')

class DummyImporter
    include Decidim::FormFactory
    def current_organization
        Decidim::Organization.first
    end

    def current_user
        Decidim::User.first
    end
end

hash_to_import = {"assembly"=>{"title_pt__BR" => "4confjuv", "slug"=> "confjuv4", "document"=>blob3, "document_validation"=>"1", "import_steps"=>"1", "import_categories"=>"1", "import_attachments"=>"0", "import_components"=>"1", 'current_organization' => Decidim::Organization.first, 'organization_id' => 1, 'organization' => Decidim::Organization.first}}
form = DummyImporter.new.form(Decidim::Assemblies::Admin::AssemblyImportForm).from_params(hash_to_import)

Decidim::Assemblies::Admin::ImportAssembly.call(form, Decidim::User.first) do
    on(:ok) do
        puts 'Assembleia "4confjuv" importada com sucesso.'
    end
    on(:invalid) do
        puts 'Ocorreu um erro ao importar a assembleia "4confjuv".'
    end
end

file4 = File.open(Rails.root.join('db', 'seeds', 'assemblies-cnsan6.json'))
blob4 = ActiveStorage::Blob.create_and_upload!(io: file4, filename: 'assemblies-cnsan6.json')

class DummyImporter
    include Decidim::FormFactory
    def current_organization
        Decidim::Organization.first
    end

    def current_user
        Decidim::User.first
    end
end

hash_to_import = {"assembly"=>{"title_pt__BR" => "6ª Conferência Nacional da Segurança Alimentar", "slug"=> "cnsan6", "document"=>blob4, "document_validation"=>"1", "import_steps"=>"1", "import_categories"=>"1", "import_attachments"=>"0", "import_components"=>"1", 'current_organization' => Decidim::Organization.first, 'organization_id' => 1, 'organization' => Decidim::Organization.first}}
form = DummyImporter.new.form(Decidim::Assemblies::Admin::AssemblyImportForm).from_params(hash_to_import)

Decidim::Assemblies::Admin::ImportAssembly.call(form, Decidim::User.first) do
    on(:ok) do
        puts 'Assembleia "6a Conferencia Nacional da Segurança Alimentar" importada com sucesso.'
    end
    on(:invalid) do
        puts 'Ocorreu um erro ao importar a assembleia "6a Conferencia Nacional da Segurança Alimentar".'
    end
end

