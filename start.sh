#!/bin/sh
set -e

# runs db:drop, db:create and db:migrate.
# We can't use db:schema:load because we don't have the db/schema.rb
# file when we create the app for the first time and migrations haven't
# been run yet.
#bundle exec rake db:migrate:reset
# Adds basic system, admin and user accounts, and lorem ipsum content.
#bundle exec rake db:seed

#exec "$@"

bundle check || bundle install

# bundle exec rake db:migrate:reset
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

mailcatcher --http-ip=0.0.0.0 &
bundle exec sidekiq & 
bundle exec rails s -p 3000 -b 0.0.0.0