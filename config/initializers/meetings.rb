Decidim.component_registry.find(:meetings).settings do |settings|
  settings.attribute :attachments_allowed, type: :boolean, default: false
end
