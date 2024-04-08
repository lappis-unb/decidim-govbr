# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      # A form object to be used when admin users want to create a proposal
      # through the participatory texts.
      class ParticipatoryTextProposalForm < Admin::ProposalBaseForm
        attribute :title, String
        attribute :body, String
        attribute :is_interactive, Boolean
        attribute :deleted, Boolean, default: false

        validates :title, length: { maximum: 150 }, presence: true, if: :should_persist?

        def should_persist?
          !deleted
        end

        def map_model(model)
          self.title = translated_attribute(model.title)
          self.body = translated_attribute(model.body)
          self.is_interactive = model.is_interactive
        end
      end
    end
  end
end
