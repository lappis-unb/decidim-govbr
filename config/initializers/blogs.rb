Rails.logger.info "Starting blogs"


Decidim.component_registry.find(:blogs).settings(:global) do |settings|
  settings.attribute :enable_comments_attachment, type: :boolean, default: false
end


Rails.logger.info "Finished blogs"