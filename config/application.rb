require_relative 'boot'

require 'decidim/rails'
require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Decide
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.time_zone = 'Brasilia'

    config.active_job.queue_adapter = :sidekiq

    config.i18n.load_path += Dir['config/locales/**/*.yml']

    config.to_prepare do
      list = Dir.glob("#{Rails.root}/lib/extends/**/*.rb")
      concerns = list.select { |obj| obj.include?('concerns/') }
      if concerns.any?
        concerns.each { |concern| puts "Concern: #{concern}" }
        raise Exception, %(
        It looks like you're going to add an extension of a decidim concern.
        Putting it into lib/extends/ will lead to issues.
        Please override any of decidim concerns through classic monkey-patching and put them in the app/ folder.
      )
      end
      list.each { |override| require_dependency override }
    end
  end
end
