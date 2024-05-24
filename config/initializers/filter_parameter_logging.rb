# Be sure to restart your server when you modify this file.

Rails.logger.info "Starting filter_parameter_logging"

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password]

Rails.logger.info "Finished filter_parameter_logging"