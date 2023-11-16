# frozen_string_literal: true

module Decidim
  module Govbr
    # A custom mailer for sending e-mail notifications to users
    # when they get promoted to admin.
    class PromotedToAdminMailer < Decidim::ApplicationMailer
      include Decidim::TranslationsHelper
      include ActionView::Helpers::SanitizeHelper
      include Decidim::ApplicationHelper

      helper Decidim::ResourceHelper
      helper Decidim::TranslationsHelper
      helper Decidim::ApplicationHelper

      def notification(user)
        with_user(user) do
          @user = user
          @organization = user.organization
          @locator = Decidim::UserPresenter.new(@user)
          subject = I18n.t('notification.subject', scope: 'decidim.govbr.promoted_to_admin_mailer', organization: @organization.name)

          mail(to: user.email, subject: subject)
        end
      end
    end
  end
end
