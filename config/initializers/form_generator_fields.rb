require 'rails/generators'

module FormGenerator
  class FormGeneratorFields < Rails::Generators::Base
    argument :file_name, type: :string, banner: "file_name"
    argument :fields, type: :array, default: [], banner: "field:type field:type"

    def generate_form
      create_file "vendor/decidim-module-homes/app/views/decidim/homes/admin/home_elements/_#{file_name}.html.erb", generate_form_content
      create_file "vendor/decidim-module-homes/app/views/decidim/homes/application/_#{file_name}.html.erb", generate_user_content
    end

    private

    def generate_user_content
      content = ""
      form_fields.each do |field|
        content += "<%= properties[\"#{field[:name]}\"] %>\n"
      end
      content
    end

    def generate_form_content
      content = "<%= f.fields_for :properties do |header_form| %>\n"

      form_fields.each do |field|
        field_type = "#{field[:type]}_field"
        content += "  <%= header_form.#{field_type} :#{field[:name]},\n"
        content += "    label: \"#{field[:label]}\",\n"
        content += "    value: @home_element.properties['#{field[:name]}'],\n"
        content += "    placeholder: \"#{field[:placeholder]}\"\n"
        content += "  %>\n"
      end

      content += "<% end %>\n"
      content
    end

    def form_fields
      fields.map do |field|
        field_name, field_type = field.split(':')
        {
          name: field_name,
          type: field_type,
          label: field_name.humanize,
          placeholder: "Preencha o #{field_name.humanize.downcase}"
        }
      end
    end
  end
end
