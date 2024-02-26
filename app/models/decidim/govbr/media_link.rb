# frozen_string_literal: true

module Decidim
  module Govbr
    # This model holds external links to be shared amongst all the participatory
    # space visitors. It's meant to be displayed for everyone
    #
    class MediaLink < ApplicationRecord
      self.table_name = "decidim_govbr_media_links"

      include Decidim::Traceable
      include Decidim::Loggable
      include Decidim::TranslatableResource

      translatable_fields :title

      belongs_to :participatory_space, polymorphic: true

      def self.log_presenter_class_for(_log)
        Decidim::Govbr::AdminLog::MediaLinkPresenter
      end
    end
  end
end
