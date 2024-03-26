NilClass.class_eval do 
  def has_key?(*args,**kargs)
    Rails.logger.error "(STACK TRACE CUSTOMIZADO): undefined method has_key? for nil::NilClass args => #{args}"
    Rails.logger.error "(STACK TRACE CUSTOMIZADO): has_key? stack trace => #{caller_locations.join("\n")}"
    raise NoMethodError, "undefined method has_key? for nil::NilClass"
  end
end