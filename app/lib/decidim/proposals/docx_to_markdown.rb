# frozen_string_literal: true

require "pandoc-ruby"
require "tempfile"

module Decidim
  module Proposals
    # This class parses a participatory text document in markdown and
    # produces Proposals in the form of sections and articles.
    #
    # This implementation uses Redcarpet Base renderer.
    # Redcarpet::Render::Base performs a callback for every block it finds, what MarkdownToProposals
    # does is to implement callbacks for the blocks which it is interested in performing some actions.
    #
    class DocxToMarkdown
      # Public: Initializes the serializer with a proposal.
      def initialize(doc)
        @doc = doc
      end

      def to_md
        doc_file = doc_to_tmp_file
        md_str = transform_to_md_file(doc_file)
        sanitize_markdown(md_str)
      end

      #-----------------------------------------------------

      private

      #-----------------------------------------------------

      def doc_to_tmp_file
        file = File.new("doc-to-markdown-docx.docx", "wb+")
        file.write(@doc)
        file
      end

      def transform_to_md_file(doc_file)
        file_to_parse = PandocRuby.docx(File.read(doc_file))
        file_to_parse.convert(to: :markdown_strict, output: "markdown.md", wrap: "none")
        File.read("markdown.md")
      end

      def sanitize_markdown(markdown_str)
        new_str = sanitize_ordered_lists(markdown_str)
        new_str = sanitize_unordered_lists(new_str)
        new_str = sanitize_script_tags(new_str)
        sanitize_images(new_str)
      end

      def sanitize_ordered_lists(markdown_str)
        new_str = markdown_str.gsub(/(?:\d+\.\s\s.+)\n\n/i) do |item|
          item.gsub(/\n\n/, "\n")
        end

        new_str.gsub(/(?:\d+\.\s\s.+)\n(?:\D)/i) do |item|
          item.gsub(/\n/, "\n\n")
        end
      end

      def sanitize_unordered_lists(markdown_str)
        new_str = markdown_str.gsub(/-(?:\s\s\s.+)\n\n/i) do |item|
          item.gsub(/-/, "*").gsub(/\n\n/, "\n")
        end

        new_str.gsub(/(?:\*\s\s\s.+)\n(?:[^*])/i) do |item|
          item.gsub(/\n/, "\n\n")
        end
      end

      def sanitize_images(markdown_str)
        user_message = "[INSIRA A IMAGEM AQUI!]\n\n"

        markdown_str.gsub(%r{<img.*/>}) do |img_tag|
          img_tag.gsub(%r{<img.*/>}, user_message)
        end
      end

      def sanitize_script_tags(participatory_text)
        script_tags = %r{&lt;script&gt;.*&lt;/script&gt;}

        participatory_text = participatory_text.gsub(script_tags, '') if script_tags.match?(participatory_text)

        participatory_text
      end
    end
  end
end
