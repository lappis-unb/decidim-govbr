Decidim.component_registry.find(:blogs).settings(:global) do |settings|
  settings.attribute :enable_comments_attachment, type: :boolean, default: true
end