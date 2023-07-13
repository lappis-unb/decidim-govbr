#!/usr/bin/env ruby

Decidim::System::Admin.new(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD']).save!(validate: false)