Decidim.component_registry.find(:proposals).settings(:global) do |settings|
  settings.attribute :most_voted_rule, type: :integer, default: 0
  settings.attribute :enable_comments_attachment, type: :boolean, default: true
  settings.attribute :requires_previous_moderation, type: :boolean, default: false
end

# This is necessary to be compatible with decidim awesome 0.10.2
Decidim::Proposals::ProposalSerializer.class_eval do
  include HtmlToPlainText

  # Recursively strips HTML tags from given Hash strings using convert_to_text from Premailer
  def convert_to_plain_text(value)
    return value.transform_values { |v| convert_to_plain_text(v) } if value.is_a?(Hash)

    convert_to_text(value)
  end
end
