# frozen_string_literal: true

module Decidim
  module Comments
    # A form object used to create comments from the graphql api.
    #
    class CommentForm < Form
      include Decidim::Govbr::MediaAttachmentsHelper

      attribute :body, Decidim::Attributes::CleanString
      attribute :alignment, Integer
      attribute :user_group_id, Integer
      attribute :commentable
      attribute :commentable_gid
      attribute :status, String
      attribute :attachment_file

      mimic :comment

      ACCEPTED_TYPES = [
        'application/pdf'
      ].freeze

      validates :body, presence: true, length: { maximum: ->(form) { form.max_length } }
      validates :alignment, inclusion: { in: [0, 1, -1] }, if: ->(form) { form.alignment.present? }
      validate :document_type_must_be_valid, if: :attachment_file
      validate :document_size_must_be_valid, if: :attachment_file

      validate :max_depth

      def max_length
        if current_component.try(:settings).respond_to?(:comments_max_length)
          component_length = current_component.try { settings.comments_max_length.positive? }
          return current_component.settings.comments_max_length if component_length
        end
        return current_organization.comments_max_length if current_organization.comments_max_length.positive?

        1000
      end

      def max_depth
        return unless commentable.respond_to?(:depth)

        errors.add(:base, :invalid) if commentable.depth >= Comment::MAX_DEPTH
      end

      def max_file_size
        1_000_000
      end

      def document_size_must_be_valid
        document_size = blob(attachment_file).byte_size

        if document_size > max_file_size
          max_file_size_in_mb = max_file_size / 1_000_000
          errors.add(:attachment_file, "O tamanho máximo permitido é #{max_file_size_in_mb} megabytes")
        end
      end

      def document_type_must_be_valid
        document_type = blob(attachment_file).content_type
        return if ACCEPTED_TYPES.include?(document_type)

        errors.add(:attachment_file, "Somente arquivos pdf são permitidos")
      end
    end
  end
end
