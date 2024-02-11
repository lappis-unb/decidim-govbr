# frozen_string_literal: true

module Decidim
  module Assemblies
    module Admin
      # Controller that allows managing assembly supporters and organizers.
      #
      class PartnersController < Decidim::Assemblies::Admin::ApplicationController
        include Concerns::AssemblyAdmin
        include Decidim::Paginable

        def index
          enforce_permission_to :index, :partner

          @partners = paginate(collection)
        end

        def new
          enforce_permission_to :create, :partner
          @form = form(Decidim::Assemblies::Admin::PartnerForm).instance
        end

        def create
          enforce_permission_to :create, :partner
          @form = form(Decidim::Assemblies::Admin::PartnerForm).from_params(params)

          Decidim::Govbr::Admin::CreatePartner.call(@form, current_user, current_assembly) do
            on(:ok) do
              flash[:notice] = I18n.t("partners.create.success", scope: "decidim.admin")
              redirect_to assembly_partners_path(current_assembly)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("partners.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          @partner = collection.find(params[:id])
          enforce_permission_to :update, :partner, partner: @partner
          @form = form(Decidim::Assemblies::Admin::PartnerForm).from_model(@partner)
        end

        def update
          @partner = collection.find(params[:id])
          enforce_permission_to :update, :partner, partner: @partner
          @form = form(Decidim::Assemblies::Admin::PartnerForm).from_params(params)

          Decidim::Govbr::Admin::UpdatePartner.call(@form, @partner) do
            on(:ok) do
              flash[:notice] = I18n.t("partners.update.success", scope: "decidim.admin")
              redirect_to assembly_partners_path(current_assembly)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("partners.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        def destroy
          @partner = collection.find(params[:id])
          enforce_permission_to :destroy, :partner, partner: @partner

          Decidim::Govbr::Admin::DestroyPartner.call(@partner, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("partners.destroy.success", scope: "decidim.admin")
              redirect_to assembly_partners_path(current_assembly)
            end
          end
        end

        private

        def collection
          @collection ||= current_assembly.partners
        end
      end
    end
  end
end
