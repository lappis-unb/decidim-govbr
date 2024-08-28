# frozen_string_literal: true

module Decidim
  module Verifications
    # A command to create a partial authorization for a user.
    class PerformAuthorizationStep < Decidim::Command
      # Public: Initializes the command.
      #
      # authorization - An Authorization object.
      # handler - An AuthorizationHandler object.
      def initialize(authorization, handler)
        @authorization = authorization
        @handler = handler
        @user = authorization.user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the handler wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) unless handler.valid?

        update_verification_data

        # User need to be informed if they was rejected, and their account need to be confirmed
        user.send_confirmation_instructions if handler.verification_metadata.try(:[], 'rejected')

        broadcast(:ok)
      end

      protected

      # This is overridden by decidim-extra_user_fields
      #
      def update_verification_data
        authorization.attributes = {
          unique_id: handler.unique_id,
          metadata: handler.metadata,
          verification_metadata: handler.verification_metadata,
          verification_attachment: handler.verification_attachment
        }

        authorization.save!
      end

      private

      attr_reader :authorization, :handler, :user
    end
  end
end
