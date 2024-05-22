Decidim.component_registry.find(:meetings).settings do |settings|
  settings.attribute :enable_comments_attachment, type: :boolean, default: false
end