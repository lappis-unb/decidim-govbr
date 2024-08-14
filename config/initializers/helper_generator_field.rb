require 'rails/generators'

module HelperGenerator
  class HelperGeneratorField < Rails::Generators::Base
    argument :component_name, type: :string, required: true, desc: "O nome do componente a ser adicionado"
    argument :component_translation, type: :string, required: true, desc: "A tradução do nome do componente"

    def add_component_helper
      file_path = "vendor/decidim-module-homes/app/helpers/decidim/homes/application_helper.rb"
      yaml_path = "vendor/decidim-module-homes/config/locales/pt-BR.yml"

      add_to_helper(file_path)
      add_to_yaml(yaml_path)
    end

    private

    def add_to_helper(file_path)
      if File.exist?(file_path)
        content = File.read(file_path)

        if content.include?(component_name)
          puts "Componente '#{component_name}' já existe no helper."
        else
          new_line = "          OpenStruct.new(name: \"#{component_name}\"),\n"

          updated_content = content.sub(/(\[\n)(.*\n)*(\s*\])/m) do |match|
            match.sub(/^\s*\]/, "#{new_line}        ]")
          end

          File.write(file_path, updated_content)
          puts "Componente '#{component_name}' adicionado com sucesso ao helper!"
        end
      else
        puts "Arquivo não encontrado: #{file_path}"
      end
    end

    def add_to_yaml(yaml_path)
      if File.exist?(yaml_path)
        yaml_content = File.read(yaml_path)

        if yaml_content.include?(component_name)
          puts "Componente '#{component_name}' já existe no YAML."
        else
          insertion_point = yaml_content.match(/components:\n/)
          new_translation_line = "      #{component_name}:\n          name: \"#{component_translation}\"\n"

          updated_yaml_content = yaml_content.sub(insertion_point[0], "#{insertion_point[0]}#{new_translation_line}")

          File.write(yaml_path, updated_yaml_content)
          puts "Tradução '#{component_translation}' para '#{component_name}' adicionada com sucesso no YAML!"
        end
      else
        puts "Arquivo YAML não encontrado: #{yaml_path}"
      end
    end
  end
end
