Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Eager load code on boot.
  config.eager_load = true

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  elsif ENV['REDIS_CACHE_URL'].present?
    config.action_controller.perform_caching = true

    config.cache_store = :redis_cache_store, { url: ENV['REDIS_CACHE_URL'].split(',') }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = Rails.application.secrets.dig(:storage, :provider) || :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  # config.action_mailer.delivery_method = :letter_opener_web
  # config.action_mailer.default_url_options = { port: 3000 }

  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'localhost',
    port: 1025
  }

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.webpacker.check_yarn_integrity = false

  config.hosts << ENV.fetch('ALLOW_HOSTS')

  config.log_formatter = proc do |severity, datetime, _progname, msg|
    if %w(ERROR FATAL).include?(severity)
      "\e[31m[#{datetime}] #{severity} -- #{msg}\e[0m\n"
    else
      "[#{datetime}] #{severity} -- #{msg}\n"
    end
  end
end
