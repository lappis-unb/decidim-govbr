# frozen_string_literal: true

module Decidim
  module Govbr
    # A custom mailer for sending e-mail notifications to users
    # when they get their confirmation approved
    #
    class RegistrationVerificationMailer < Decidim::ApplicationMailer
      include Decidim::TranslationsHelper
      include ActionView::Helpers::SanitizeHelper
      include Decidim::ApplicationHelper

      helper Decidim::ResourceHelper
      helper Decidim::TranslationsHelper
      helper Decidim::ApplicationHelper

      def confirmation_pending(user)
        with_user(user) do
          @user = user
          @organization = user.organization
          @locator = Decidim::OrganizationPresenter.new(@organization)
          subject = "#{@locator.name} - Registration under analysis"

          mail(to: user.email, subject: subject)
        end
      end

      def confirmation_approved(user)
        with_user(user) do
          @user = user
          @organization = user.organization
          @locator = Decidim::OrganizationPresenter.new(@organization)
          subject = "#{@locator.name} - Registration approved"

          mail(to: user.email, subject: subject)
        end
      end
    end
  end
end
