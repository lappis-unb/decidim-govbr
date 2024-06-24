# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      # A form object to be used when admin users want to answer a proposal.
      class ProposalAnswerForm < Decidim::Form
        include TranslatableAttributes
        mimic :proposal_answer

        translatable_attribute :answer, String
        translatable_attribute :cost_report, String
        translatable_attribute :execution_period, String
        attribute :cost, Float
        attribute :internal_state, String
        attribute :badge, String

        validates :internal_state, presence: true, inclusion: { in: Decidim::Proposals::Proposal::POSSIBLE_STATES }
        validates :answer, translatable_presence: true, if: ->(form) { form.state.in?(states_that_requires_answer) }

        with_options if: :costs_required? do
          validates :cost, numericality: true, presence: true
          validates :cost_report, translatable_presence: true
          validates :execution_period, translatable_presence: true
        end

        alias state internal_state

        def costs_required?
          costs_enabled? && state == "accepted"
        end

        def publish_answer?
          current_component.current_settings.publish_answers_immediately?
        end

        private

        def states_that_requires_answer
          %w(rejected disqualified)
        end

        def costs_enabled?
          current_component.current_settings.answers_with_costs?
        end
      end
    end
  end
end
