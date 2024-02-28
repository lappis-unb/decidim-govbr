module Decidim
  module Admin
    class HtmlBlockRegistration < Decidim::Command
      def self.register_dynamic_html_block(block_count)
        Decidim.content_blocks.register(:homepage, :"html_#{block_count}".to_sym) do |content_block|
          content_block.cell = "decidim/content_blocks/html"
          content_block.public_name_key = "decidim.content_blocks.html.name"
          content_block.settings_form_cell = "decidim/content_blocks/html_settings_form"
          active_blocks = Decidim::ContentBlock.for_scope(:homepage, organization: Decidim::Organization.first).published

          content_block.settings do |settings|
            settings.attribute :html_content, type: :text, translated: true
          end
        end
      end
    end
  end
end
