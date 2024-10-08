# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      # A form object to be used when admin users want to review a collection of proposals
      # from a participatory text.
      class PreviewParticipatoryTextForm < Decidim::Form
        attribute :proposals, Array[Decidim::Proposals::Admin::ParticipatoryTextProposalForm]
        attribute :proposal_to_add, String

        validates :proposal_to_add, inclusion: { in: Decidim::Proposals::ParticipatoryTextSection::LEVELS.values }, if: :should_create_new_proposal?

        def should_create_new_proposal?
          proposal_to_add.present?
        end

        def from_models(proposals)
          self.proposals = proposals.collect do |proposal|
            Admin::ParticipatoryTextProposalForm.from_model(proposal)
          end
        end

        def proposals_attributes=(attributes); end
      end
    end
  end
end
