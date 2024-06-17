# frozen_string_literal: true

module Decidim
  module Admin
    # This command gets called when a component is created from the admin panel.
    class UpdateBadgeProposals < Decidim::Command
      attr_reader :current_component, :user

      # Public: Initializes the command.
      #
      # form    - The form from which the data in this component comes from.
      # proposal - The proposal to update.
      def initialize(current_component, user)
        @component = current_component
        @user = user
      end

      # Public: Creates the Component.
      #
      # Broadcasts :ok if created, :invalid otherwise.
      def call
        Decidim.traceability.perform_action!("update", @component, @user) do
          transaction do
            insert_proposal_most_voted_label
          end
        end
        broadcast(:ok)
      end

      private

      def insert_proposal_most_voted(proposal)
        badge_array = proposal.badge_array

        if badge_array.exclude?("Mais Votada")
          badge_array << "Mais Votada"
          proposal.update(badge_array: badge_array)
        end
      end

      def insert_proposal_most_voted_label
        ten_most_voted_proposals.each do |proposal|
          insert_proposal_most_voted(proposal)
        end
      end

      def reorder_by_votes
        proposals = Decidim::Proposals::Proposal.where(component: @component)
        proposals.order(proposal_votes_count: :desc)
      end

      def ten_most_voted_proposals
        reorder_by_votes.limit(10)
      end
    end
  end
end
