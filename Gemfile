# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
git_source(:gitlab) { |repo| "https://gitlab.com/#{repo}.git" }

ruby RUBY_VERSION

DECIDIM_VERSION = '0.27.2'

# CALENDAR_REPO = { path: '../decidim-module-calendar' }.freeze
CALENDAR_REPO = { gitlab: 'nomadetec/decidim-module-calendar' }.freeze

gem 'decidim', DECIDIM_VERSION
# gem 'decidim-calendar', CALENDAR_REPO
gem 'decidim-conferences', DECIDIM_VERSION
gem 'decidim-consultations', DECIDIM_VERSION
gem 'decidim-initiatives', DECIDIM_VERSION
gem 'decidim-apiauth', github: 'mainio/decidim-module-apiauth'
gem 'omniauth_openid_connect', '0.6.1'
gem 'decidim-decidim_awesome', '0.10.2'

gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'bootsnap', '1.13.0'

gem 'puma', '5.6.5'
gem 'uglifier', '~> 4.1'

gem 'faker', '~> 2.17'

gem 'devise-i18n'

gem 'redis', '4.7.1'
gem 'hiredis', '0.6.3'
gem 'sidekiq', '6.5.7'

gem 'whenever', require: false

gem 'decidim-homes', git: 'https://gitlab.com/lappis-unb/decidimbr/components-brasil-participativo/decidim-module-homes.git'
gem 'decidim-extra_user_fields', git: 'https://gitlab.com/lappis-unb/decidimbr/decidim-extra_user_fields.git', branch: 'feat/allow-to-configure-permitted-components'
gem 'decidim-ej', git: 'https://gitlab.com/lappis-unb/decidimbr/components-brasil-participativo/decidim-ej.git', branch: 'main'

gem "rest-client", "~> 2.1"

gem "pandoc-ruby", '2.1.10'

group :development, :test do
  gem 'byebug', '11.1.3'
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'pry-nav'
  gem "rubocop-faker", "~> 1.1"
end

group :development do
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'rails-erd'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
end

group :production do
  gem 'aws-sdk-s3', require: false
  gem 'elastic-apm', '4.7.0'
end
