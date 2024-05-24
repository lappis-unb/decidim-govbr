# frozen_string_literal: true

Rails.logger.info "Starting social_share_button"

# Further information on how to configure the SocialShareButton gem can be
# found here: https://github.com/huacnlee/social-share-button#configure
#
SocialShareButton.configure do |config|
  config.allow_sites = %w(twitter facebook whatsapp_app whatsapp_web telegram)
end

Rails.logger.info "Finished social_share_button"