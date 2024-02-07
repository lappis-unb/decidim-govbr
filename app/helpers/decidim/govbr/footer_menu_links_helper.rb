module Decidim
  module Govbr
    module FooterMenuLinksHelper

      def render_footer_menu_links(current_organization)
        footer_menu_items = current_organization.try(:footer_menu_links).try(:[], 'menu') || []
        visible_footer_menu_items = footer_menu_items.filter { |item| item['is_visible'] }
        
        angle_icon_down = content_tag(:div, '', class: 'support') do
          content_tag(:i, '', class: 'fas fa-angle-down')
        end

        visible_footer_menu_items.map do |item|
          if item['is_topic']
            content_tag(:div, class: 'br-col-2', id: item['id']) do
              link_content = content_tag(:a, class: 'br-item header', href: item['href']) do
                content_tag(:div, item['label'], class: 'content text-down-01 text-bold text-uppercase') +
                (item['sub_items'].present? ? angle_icon_down : '')
              end 
              
              
              
              if item['sub_items'].present?
                link_content += content_tag(:div, class: 'br-list') do
                  item['sub_items'].map do |sub_item|
                    render_footer_menu_link_with_sub_links(sub_item)
                  end.join('').html_safe
                end
              end

              link_content
            end
          end
        end.join('').html_safe
      end


      def render_footer_menu_link_with_sub_links(footer_menu_item)
            content_tag(:a, class: 'br-item', href: footer_menu_item['href']) do
              content_tag(:div, footer_menu_item['label'], class: 'content')
            end
      end
    end
  end
end
