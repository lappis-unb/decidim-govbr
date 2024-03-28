# frozen_string_literal: true

module Decidim
  module Proposals
    # A form object to be used when public users want to create a proposal.
    class ProposalWizardCreateStepForm < Decidim::Form
      include Decidim::AttachmentAttributes

      mimic :proposal

      attribute :title, String
      attribute :body, Decidim::Attributes::CleanString
      attribute :body_template, String
      attribute :user_group_id, Integer
      attribute :category_id, Integer
      attribute :attachment, AttachmentForm

      attachments_attribute :photos
      attachments_attribute :documents

      validates :title, :body, presence: true, etiquette: true
      validates :title, length: { in: 15..150 }
      validates :body, length: { in: 15..5000 }

      validate :body_is_not_bare_template

      delegate :categories, to: :current_component

      alias component current_component

      def map_model(model)
        self.title = translated_attribute(model.title)
        self.body = translated_attribute(model.body)

        self.user_group_id = model.user_groups.first&.id
        return unless model.categorization

        self.category_id = model.categorization.decidim_category_id
        self.photos = [model.photo].compact.select { |p| p.weight.zero? }
        self.documents = model.attachments - photos
      end

      def category
        @category ||= categories.find_by(id: category_id)
      end

      private

      def body_is_not_bare_template
        return if body_template.blank?

        errors.add(:body, :cant_be_equal_to_template) if body.presence == body_template.presence
      end
    end
  end
end
