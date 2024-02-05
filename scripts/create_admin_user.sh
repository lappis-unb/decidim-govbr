#!/bin/sh

exec rails runner "eval(File.read 'scripts/rails_admin.rb')"