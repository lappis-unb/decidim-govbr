Decidim.component_registry.find(:proposals).settings(:global) do |settings|
  settings.attribute :most_voted_rule, type: :integer, default: 0
end