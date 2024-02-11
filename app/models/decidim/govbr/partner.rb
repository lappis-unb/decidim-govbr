# frozen_string_literal: true

module Decidim
  module Govbr
    class Partner < ApplicationRecord
      self.table_name = "decidim_govbr_partners"

      include Decidim::Traceable
      include Decidim::Loggable
      include Decidim::HasUploadValidations

      TYPES = %w[supporter organizer].freeze

      belongs_to :partnerable, polymorphic: true

      default_scope { order(partner_type: :desc, weight: :asc) }

      has_one_attached :logo
      validates_avatar :logo, uploader: Decidim::Conferences::PartnerLogoUploader

      delegate :organization, to: :partnerable

      alias participatory_space partnerable

      def self.log_presenter_class_for(_log)
        Decidim::Govbr::AdminLog::PartnerPresenter
      end
    end
  end
end