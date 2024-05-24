Rails.logger.info "Starting wisper"


Wisper.configure do |config|
  config.broadcaster :default, Wisper::Broadcasters::LoggerBroadcaster.new(Rails.logger, Wisper::Broadcasters::SendBroadcaster.new)
end


Rails.logger.info "Finished wisper"