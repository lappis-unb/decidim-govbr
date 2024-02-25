module Decidim
  module Govbr
    module NewsAdminHelper # rubocop:disable Style/Documentation
      def edit_news_admin_href(current_url)
        participatory_path = request.path.split('/')[2]
        news_id = current_url.split('/').last
        component_id = current_url.split('/')[4]
        component_name = current_url.split('/')[1]

        entity_type = case component_name
                      when 'assemblies'
                        'assemblies'
                      when 'processes'
                        'participatory_processes'
                      end

        "/admin/#{entity_type}/#{participatory_path}/components/#{component_id}/manage/posts/#{news_id}/edit"
      end

      def create_news_admin_href(current_url)
        participatory_path = request.path.split('/')[2]
        component_id = current_url.split('/')[4]
        component_name = current_url.split('/')[1]

        entity_type = case component_name
                      when 'assemblies'
                        'assemblies'
                      when 'processes'
                        'participatory_processes'
                      end

        "/admin/#{entity_type}/#{participatory_path}/components/#{component_id}/manage/posts/new"
      end
    end
  end
end
