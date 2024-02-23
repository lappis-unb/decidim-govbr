# frozen_string_literal: true

module Decidim
  module Admin
    module Govbr
      class AutofillMenuLinks < Decidim::Command
        attr_reader :form, :component, :previous_settings


        def initialize(user)
          @user = user
        end

        # Public: Creates the Component.
        #
        # Broadcasts :ok if created, :invalid otherwise.
        def call
          return update_organization ? broadcast(:ok) : broadcast(:invalid)
        end

        private

        def get_components_links(spaces, space_label)
          spaces_links = spaces.map do |space|
            links = space.components.map do |component|
              label = component.respond_to?('name') ? 'name' : 'title'
              label_pt_br = component.send(label)['pt-br'] || component.send(label)['pt'] || 'Componente'
              url = "/#{space_label}/#{space.slug}/f/#{component.id}"
              { 'id' => (label_pt_br + '_' + component.id.to_s), 'label' => label_pt_br, 'href' => url, "is_visible"=> true }
            end
            label_pt_br = space.send('title')['pt-br'] || space.send('title')['pt'] || 'Espaço'
            { 'id' => (space_label + '_' + space.id.to_s), 'label' => label_pt_br, 'sub_items' => links, "is_visible"=> true }
          end
          spaces_links
        end

        def generate_menu_links
          processes = get_components_links(Decidim::ParticipatoryProcess.all, 'processes')
          assemblies = get_components_links(Decidim::Assembly.all, 'assemblies')

          result = processes + assemblies
          { 'menu' => result }.to_json.to_s.gsub(':', '=>')
        end

        def update_organization
          current_organization.update(menu_links: generate_menu_links)
        end

      end
    end
  end
end
