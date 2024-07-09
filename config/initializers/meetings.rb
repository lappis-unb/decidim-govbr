Decidim.component_registry.find(:meetings).settings(:global) do |settings|
  settings.attribute :attachments_allowed, type: :boolean, default: false
  settings.attribute :enable_comments_attachment, type: :boolean, default: true
end
