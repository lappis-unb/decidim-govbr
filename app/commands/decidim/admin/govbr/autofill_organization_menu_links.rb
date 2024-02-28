# frozen_string_literal: true

module Decidim
  module Admin
    module Govbr
      class AutofillMenuLinks < Decidim::Command
        attr_reader :current_user

        def initialize(user)
          @current_user = user
        end

        # Public: Creates the Component.
        #
        # Broadcasts :ok if created, :invalid otherwise.
        def call
          update_organization ? broadcast(:ok, @organization) : broadcast(:invalid)
        end

        private

        def get_components_links(spaces, space_label)
          spaces.map do |space|
            links = space.components.map do |component|
              label = component.respond_to?('name') ? 'name' : 'title'
              label_pt_br = component.send(label)['pt-br'] || component.send(label)['pt'] || 'Componente'
              url = "/#{space_label}/#{space.slug}/f/#{component.id}"
              { 'id' => "#{label_pt_br}_#{component.id}", 'label' => label_pt_br, 'href' => url, "is_visible" => true }
            end
            label_pt_br = space.send('title')['pt-br'] || space.send('title')['pt'] || 'Espaço'
            { 'id' => "#{space_label}_#{space.id}", 'label' => label_pt_br, 'sub_items' => links, "is_visible" => true }
          end
        end

        def generate_menu_links
          processes = get_components_links(Decidim::ParticipatoryProcess.all, 'processes')
          assemblies = get_components_links(Decidim::Assembly.all, 'assemblies')

          result = processes + assemblies
          { 'menu' => result }.to_json.to_s.gsub(':', '=>')
        end

        def update_organization
          @organization = Decidim.traceability.update!(
            current_organization,
            current_user,
            menu_links: generate_menu_links
          )
        end
      end
    end
  end
end
