class MessageFormatter < ActiveSupport::Logger::SimpleFormatter
  def call(severity, time, progname, message)
    {
      time: time,
      level: severity,
      progname: progname,
      message: message
    }.to_json + "\n"
  end
end