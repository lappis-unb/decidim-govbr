module Decidim
    module Govbr
      module NewsAdminHelper # rubocop:disable Style/Documentation
        def generate_admin_href(current_url)
          url_parts = current_url.split('/')
          base_url = 'http://localhost:3000/admin/'

          entity_type =
            if url_parts.include?('processes')
              'participatory_processes'
            elsif url_parts.include?('assemblies')
              'participatory_assemblies'
            end

          component_id = url_parts[url_parts.index('f') + 1]
          post_id = url_parts.last

          "#{base_url}#{entity_type}/programas/components/#{component_id}/manage/posts/#{post_id}/edit"
        end
      end
    end
  end
module Decidim
    module Govbr
      module NewsAdminHelper # rubocop:disable Style/Documentation
        def generate_admin_href(current_url)
          url_parts = current_url.split('/')
          base_url = 'http://localhost:3000/admin/'

          entity_type =
            if url_parts.include?('processes')
              'participatory_processes'
            elsif url_parts.include?('assemblies')
              'participatory_assemblies'
            end

          component_id = url_parts[url_parts.index('f') + 1]
          post_id = url_parts.last

          "#{base_url}#{entity_type}/programas/components/#{component_id}/manage/posts/#{post_id}/edit"
        end
      end
    end
  end
