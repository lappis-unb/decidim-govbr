# config/initializers/some_initializer.rb
Rails.logger.info "Starting api_auth"


Decidim::Apiauth.configure do |config|
  config.force_api_authentication = true
end


# Your initializer code here
Rails.logger.info "Finished api_auth"
