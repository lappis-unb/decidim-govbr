module Decidim
  module ParticipatoryProcesses
    class MediaController < Decidim::ParticipatoryProcesses::ApplicationController
      include Decidim::Govbr::DisplayMedias

      def organization_participatory_processes
        @organization_participatory_processes ||= OrganizationParticipatoryProcesses.new(current_organization).query
      end

      def current_participatory_space
        return unless params[:participatory_process_slug]

        @current_participatory_space ||= organization_participatory_processes.where(slug: params[:participatory_process_slug]).or(
          organization_participatory_processes.where(id: params[:participatory_process_slug])
        ).first!
      end
    end
  end
end