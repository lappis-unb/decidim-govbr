# frozen_string_literal: true

require 'active_support/concern'

module UserInputScrubberExtend
  extend ActiveSupport::Concern

  included do
    private

    def custom_allowed_attributes
      Loofah::HTML5::SafeList::ALLOWED_ATTRIBUTES + %w[frameborder allowfullscreen] - %w[onerror]
    end

    def custom_allowed_tags
      Loofah::HTML5::SafeList::ALLOWED_ELEMENTS_WITH_LIBXML2 + %w[comment iframe]
    end
  end
end

Decidim::UserInputScrubber.include(UserInputScrubberExtend)
