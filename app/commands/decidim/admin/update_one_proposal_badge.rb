# frozen_string_literal: true

module Decidim
  module Admin
    # This command gets called when a component is created from the admin panel.
    class UpdateOneProposalBadge < Decidim::Command
      attr_reader :current_component, :user

      # Public: Initializes the command.
      #
      # form    - The form from which the data in this component comes from.
      # proposal - The proposal to update.
      def initialize(current_component, proposal_id, badge_name, user)
        @component = current_component
        @user = user
        @proposal_id = proposal_id
        @badge_name = badge_name
      end

      # Public: Creates the Component.
      #
      # Broadcasts :ok if created, :invalid otherwise.
      def call
        Decidim.traceability.perform_action!("update", @component, @user) do
          transaction do
            update_proposal_badge
          end
        end
        broadcast(:ok)
      end

      private

      def update_proposal_badge
        proposal = Decidim::Proposals::Proposal.find(@proposal_id)
        badge_array = proposal.badge_array

        if badge_array.exclude?(@badge_name)
          badge_array << @badge_name
          proposal.update(badge_array: badge_array)
        end
      end
    end
  end
end
