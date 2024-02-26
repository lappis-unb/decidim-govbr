module Decidim
  module Assemblies
    class MediaController < Decidim::Assemblies::ApplicationController
      include Decidim::Govbr::DisplayMedias

      def current_participatory_space
        return unless params[:assembly_slug]

        @current_participatory_space ||= OrganizationAssemblies.new(current_organization).query.where(slug: params[:assembly_slug]).or(
          OrganizationAssemblies.new(current_organization).query.where(id: params[:assembly_slug])
        ).first!
      end
    end
  end
end