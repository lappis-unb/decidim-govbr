# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby RUBY_VERSION

DECIDIM_VERSION = '0.26.2'

# CALENDAR_REPO = { path: '../decidim-module-calendar' }
CALENDAR_REPO = { github: 'luizsanches/decidim-module-calendar' }

gem "decidim", DECIDIM_VERSION
gem 'decidim-conferences', DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-calendar", CALENDAR_REPO

gem 'dotenv-rails', require: 'dotenv/rails-now'

gem "bootsnap", "1.13.0"

gem "puma", "5.6.5"
gem "uglifier", "~> 4.1"

gem "faker", "~> 2.17"

gem "devise-i18n"

gem 'sidekiq', '6.5.1'
gem 'redis', '4.7.1'

gem 'whenever', require: false

group :development, :test do
  gem "byebug", "11.1.3"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
  gem "rails-erd"
end
