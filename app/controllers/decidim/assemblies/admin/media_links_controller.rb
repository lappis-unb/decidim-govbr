# frozen_string_literal: true

module Decidim
  module Assemblies
    module Admin
      # Controller that allows managing assembly media links.
      class MediaLinksController < Decidim::Govbr::Admin::MediaLinksController
        include Concerns::AssemblyAdmin

        helper_method :new_participatory_space_media_link_path,
                      :edit_participatory_space_media_link_path,
                      :participatory_space_media_link_path,
                      :participatory_space_media_links_path
        # rubocop:disable Layout/ExtraSpacing
        alias new_participatory_space_media_link_path   new_assembly_media_link_path
        alias edit_participatory_space_media_link_path  edit_assembly_media_link_path
        alias participatory_space_media_link_path       assembly_media_link_path
        alias participatory_space_media_links_path      assembly_media_links_path
        # rubocop:enable Layout/ExtraSpacing
      end
    end
  end
end