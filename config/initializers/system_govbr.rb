# frozen_string_literal: true

Decidim::System::Engine.class_eval do
  routes do
    authenticate(:admin) do
      mount RailsDb::Engine => 'rails/db', as: 'rails_db'
    end
  end
end

Decidim.menu :system_menu do |menu|
  menu.add_item :database,
                'Database',
                rails_db.sql_path,
                position: 5,
                active: :inclusive
end
