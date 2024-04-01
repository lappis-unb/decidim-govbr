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
        md_str = File.read("markdown.md")
        md_str
      end

      def sanitize_markdown(markdown_str)
        new_str = markdown_str.gsub(/(?:\d+\.\s\s.+)\n\n/i) do |item|
          item.gsub(/\n\n/,"\n")
        end

        new_str.gsub(/(?:\d+\.\s\s.+)\n(?:\D)/i) do |item|
          item.gsub(/\n/,"\n\n")
        end
      end
    end
  end
end
