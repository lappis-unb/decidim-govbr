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

      included do
        helper_method :current_settings,
                      :component_settings
      end

      delegate :initial_page_type, :initial_page_component_id, to: :current_participatory_space

      def redirect_to_custom_show_page_if_necessary
        return if initial_page_type == "default" || initial_page_component_id.blank?

        if initial_page_type == "homes" && initial_page_component
          redirect_to decidim_participatory_space_homes_path(current_participatory_space, initial_page_component)
        elsif initial_page_type == "pages" && initial_page_component
          redirect_to decidim_participatory_space_pages_path(current_participatory_space, initial_page_component)
        end
      end

      def render_custom_show_page_if_necessary
        return if initial_page_type == "default" || initial_page_component_id.blank?

        if initial_page_type == "homes" && initial_page_component
          set_homes_component_context
          render template: "decidim/homes/application/show"

        elsif initial_page_type == "pages" && initial_page_component
          set_pages_component_context
          render template: "decidim/pages/application/show"
        end
      end

      def set_homes_component_context
        @home = Decidim::Homes::Home.find_by(component: initial_page_component)
        @supporters = current_participatory_space.try(:supporters) || []
        @organizers = current_participatory_space.try(:organizers) || []
        @latest_posts = Rails.cache.fetch("decidim_homes_home_#{@home.id}_blogs_#{@home.news_id}_latest_3_posts", expires_in: 2.minutes) do
          @home.news_section_enabled? ? Decidim::Blogs::Post.where(component: @home.news_id).order(created_at: :desc).limit(3) : []
        end
      end

      def set_pages_component_context
        @page = Decidim::Pages::Page.find_by(component: initial_page_component)
      end

      def initial_page_component
        return unless current_participatory_space

        @initial_page_component ||= current_participatory_space.components.where(id: initial_page_component_id, manifest_name: initial_page_type).first
      end

      def decidim_participatory_space_homes_path(*args)
        raise NotImplementedError
      end

      def decidim_participatory_space_pages_path(*args)
        raise NotImplementedError
      end

      def current_settings
        @current_settings ||= initial_page_component&.settings
      end

      def component_settings
        @component_settings ||= initial_page_component&.settings
      end
    end
  end
end
