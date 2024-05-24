# frozen_string_literal: true

Rails.logger.info "Starting devise"

Devise.setup do |config|
  config.sign_out_via = [:delete, :get]
end

Rails.logger.info "Finished devise"
