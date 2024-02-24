# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Govbr
    # This concern adds to participatory spaces the ability to have associated
    # a different component to be used as initial page, i.e. as `show` page
    #
    module HasCustomShowPage
      extend ActiveSupport::Concern

      TYPES = %w(default homes pages).freeze

      delegate :initial_page_type, :initial_page_component_id, to: :current_participatory_space

      def redirect_to_custom_show_page_if_necessary
        return if initial_page_type == "default" || initial_page_component_id.blank?

        if initial_page_type == "homes" && initial_page_component
          redirect_to decidim_participatory_space_homes_path(current_participatory_space, initial_page_component)
        elsif initial_page_type == "pages" && initial_page_component
          redirect_to decidim_participatory_space_pages_path(current_participatory_space, initial_page_component)
        end
      end

      def initial_page_component
        @initial_page_component ||= current_participatory_space.components.where(id: initial_page_component_id, manifest_name: initial_page_type).first
      end

      def decidim_participatory_space_homes_path(*args)
        raise NotImplementedError
      end

      def decidim_participatory_space_pages_path(*args)
        raise NotImplementedError
      end
    end
  end
end
