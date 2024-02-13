# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # Controller that allows managing participatory process media links.
      class MediaLinksController < Decidim::Govbr::Admin::MediaLinksController
        include Concerns::ParticipatoryProcessAdmin

        helper_method :new_participatory_space_media_link_path,
                      :edit_participatory_space_media_link_path,
                      :participatory_space_media_link_path,
                      :participatory_space_media_links_path

        alias new_participatory_space_media_link_path   new_participatory_process_media_link_path
        alias edit_participatory_space_media_link_path  edit_participatory_process_media_link_path
        alias participatory_space_media_link_path       participatory_process_media_link_path
        alias participatory_space_media_links_path      participatory_process_media_links_path
      end
    end
  end
end