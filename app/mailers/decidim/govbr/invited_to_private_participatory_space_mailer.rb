# frozen_string_literal: true

module Decidim
  module Govbr
    # A custom mailer for sending e-mail notifications to users
    # when they get invited to be a private user in a participatory space.
    class InvitedToPrivateParticipatorySpaceMailer < Decidim::ApplicationMailer
      include Decidim::TranslationsHelper
      include ActionView::Helpers::SanitizeHelper
      include Decidim::ApplicationHelper

      helper Decidim::ResourceHelper
      helper Decidim::TranslationsHelper
      helper Decidim::ApplicationHelper

      def notification(user, participatory_space)
        with_user(user) do
          @user = user
          @participatory_space = participatory_space
          @organization = participatory_space.organization
          @locator = Decidim::ResourceLocatorPresenter.new(participatory_space)
          subject = I18n.t('notification.subject', scope: 'decidim.govbr.invited_to_private_participatory_space_mailer', organization: @organization.name)

          mail(to: user.email, subject: subject)
        end
      end
    end
  end
end
