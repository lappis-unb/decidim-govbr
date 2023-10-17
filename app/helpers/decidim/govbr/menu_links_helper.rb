module Decidim
  module Govbr
    module MenuLinksHelper
      def render_menu_links(current_organization)
        menu_items = current_organization.try(:menu_links).try(:[], 'menu') || []
        visible_menu_items = menu_items.filter { |item| item['is_visible'] }

        content_tag(:nav, class: 'menu-body') do
          visible_menu_items.map do |item|
            if item['sub_items'].present?
              content_tag(:div, class: 'menu-folder', id: item['id']) do
                render_menu_link_with_sub_links(item)
              end
            else
              content_tag(:a, class: 'menu-item divider', href: item['href']) do
                content_tag(:span, item['label'], class: 'content')
              end
            end
          end.join('').html_safe
        end
      end

      def render_menu_link_with_sub_links(menu_item)
        return ''.html_safe if menu_item.blank? || !menu_item['is_visible']

        label_content = content_tag(:a, class: 'menu-item', href: menu_item['href']) do
          content_tag(:span, menu_item['label'], class: 'content')
        end

        items_content = content_tag(:ul) do
          visible_sub_links = menu_item['sub_items'].filter { |item| item['is_visible'] }

          visible_sub_links.map do |sub_link|
            content_tag(:li, class: sub_link['sub_items'].present? ? 'side-menu-testea' : '' ) do
              if sub_link['sub_items'].present?
                render_menu_link_with_sub_links(sub_link)
              else
                content_tag(:a, class: 'menu-item', href: sub_link['href'], id: sub_link['id']) do
                  content_tag(:span, sub_link['label'], class: 'content')
                end
              end
            end
          end.join('').html_safe
        end

        (label_content + items_content).html_safe
      end
    end
  end
end