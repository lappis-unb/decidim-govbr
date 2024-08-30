# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # A command with all the business logic when destroying a user account
      class DestroyUser < Decidim::Command
        # Public: Initializes the command.
        #
        # user - The user object to be destroyed
        # current_user - The user performing the action
        def initialize(user, current_user)
          @user = user
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if user could not be destroyed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid, :super_admin) unless current_user.super_admin?
          return broadcast(:invalid, :target_user_is_admin) if user.admin?

          transaction do
            Decidim.traceability.perform_action! :delete, user, current_user
            Decidim::Authorization.find_by(user: user)&.destroy!
            user.destroy!
          end

          return broadcast(:error) unless user.destroyed?

          broadcast(:ok)
        end

        private

        attr_reader :user, :current_user
      end
    end
  end
end
