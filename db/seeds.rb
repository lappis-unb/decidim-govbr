# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# You can remove the 'faker' gem if you don't want Decidim seeds.
# Decidim.seed!

existing_admin = Decidim::User.find_by(email: ENV['ADMIN_EMAIL'])

if existing_admin
    puts "Usuário com o e-mail #{ENV['ADMIN_EMAIL']} já existe."
else
    Decidim::System::Admin.new(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD']).save!(validate: false)
    puts "Usuário com o e-mail #{ENV['ADMIN_EMAIL']} criado."
end

organization = Decidim::Organization.find_by(host: 'localhost')

if organization
    puts "Já existe uma organização utilizando 'localhost'."
else
    brasil_participativo = Decidim::Organization.create!(
        name: 'Brasil Participativo',
        host: 'localhost',
        default_locale: 'pt-BR',
        available_locales: Decidim.available_locales,
        reference_prefix: 'brasil_participativo',
        available_authorizations: Decidim.authorization_workflows.map(&:name),
        users_registration_mode: :enabled,
        tos_version: Time.current,
        badges_enabled: true,
        user_groups_enabled: true,
        send_welcome_notification: true,
        file_upload_settings: Decidim::OrganizationSettings.default(:upload),
    )
    brasil_participativo.save!
    puts "Organização 'Brasil Participativo' criada."
end
