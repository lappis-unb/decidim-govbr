# def content_blocks
#   @content_blocks ||= Decidim::ContentBlock.for_scope(:homepage, organization: 1)
# end

# @html_blocks_count = content_blocks.where("manifest_name LIKE ?", "html%").count

# i = 2
# while i <= @html_blocks_count
#   Decidim.content_blocks.register(:homepage, "html_#{i}".to_sym) do |content_block|
#     content_block.cell = "decidim/content_blocks/html"
#     content_block.public_name_key = "decidim.content_blocks.html.name"
#     content_block.settings_form_cell = "decidim/content_blocks/html_settings_form"

#     content_block.settings do |settings|
#       settings.attribute :html_content, type: :text, translated: true
#     end
#   end
#   i += 1
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
#   puts "\e[32m#{i}"
# end