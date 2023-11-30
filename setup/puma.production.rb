# Change to match your CPU core count
workers 16

# Min and Max threads per worker
threads 10, 20

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix:///tmp/sockets/puma.sock"

# Logging
stdout_redirect "/var/log/puma.stdout.log", "/var/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "/tmp/pids/puma.pid"
state_path "/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  #ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
