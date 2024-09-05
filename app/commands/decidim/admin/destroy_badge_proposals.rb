# frozen_string_literal: true

module Decidim
  module Admin
    # This command gets called when a component is created from the admin panel.
    class DestroyBadgeProposals < Decidim::Command
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
            remove_all_labels
          end
        end

        broadcast(:ok)
      end

      private

      def remove_all_labels
        Decidim::Proposals::Proposal.where(component: @component).update_all(badge_array: [])
      end
    end
  end
end
