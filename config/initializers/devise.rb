# frozen_string_literal: true

Devise.setup do |config|
  config.sign_out_via = [:delete, :get]
end
