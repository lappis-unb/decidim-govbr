# frozen_string_literal: true

module Decidim
  module Govbr
    # This concern add the ability to have partners associated to the
    # object.
    module HasPartners
      extend ActiveSupport::Concern

      included do
        has_many :partners, as: :partnerable, class_name: "Decidim::Govbr::Partner", inverse_of: :partnerable, dependent: :destroy
      end

      def supporters
        @supporters ||= partners.select { |partner| partner.partner_type == 'supporter' }
      end

      def organizers
        @organizers ||= partners.select { |partner| partner.partner_type == 'organizer' }
      end
    end
  end
end