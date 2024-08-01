# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # Controller that allows managing participatory process supporters and organizers.
      #
      class PartnersController < Decidim::ParticipatoryProcesses::Admin::ApplicationController
        include Concerns::ParticipatoryProcessAdmin
        include Decidim::Paginable

        def index
          enforce_permission_to :index, :partner

          @partners = paginate(collection)
        end

        def new
          enforce_permission_to :create, :partner
          @form = form(Decidim::ParticipatoryProcesses::Admin::PartnerForm).instance
        end

        def create
          enforce_permission_to :create, :partner
          @form = form(Decidim::ParticipatoryProcesses::Admin::PartnerForm).from_params(params)

          Decidim::Govbr::Admin::CreatePartner.call(@form, current_user, current_participatory_process) do
            on(:ok) do
              flash[:notice] = I18n.t("partners.create.success", scope: SCOPE)
              redirect_to participatory_process_partners_path(current_participatory_process)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("partners.create.error", scope: SCOPE)
              render :new
            end
          end
        end

        def edit
          @partner = collection.find(params[:id])
          enforce_permission_to :update, :partner, partner: @partner
          @form = form(Decidim::ParticipatoryProcesses::Admin::PartnerForm).from_model(@partner)
        end

        def update
          @partner = collection.find(params[:id])
          enforce_permission_to :update, :partner, partner: @partner
          @form = form(Decidim::ParticipatoryProcesses::Admin::PartnerForm).from_params(params)

          Decidim::Govbr::Admin::UpdatePartner.call(@form, @partner) do
            on(:ok) do
              flash[:notice] = I18n.t("partners.update.success", scope: SCOPE)
              redirect_to participatory_process_partners_path(current_participatory_process)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("partners.update.error", scope: SCOPE)
              render :edit
            end
          end
        end

        def destroy
          @partner = collection.find(params[:id])
          enforce_permission_to :destroy, :partner, partner: @partner

          Decidim::Govbr::Admin::DestroyPartner.call(@partner, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("partners.destroy.success", scope: SCOPE)
              redirect_to participatory_process_partners_path(current_participatory_process)
            end
          end
        end

        private

        def collection
          @collection ||= current_participatory_process.partners
        end
      end
    end
  end
end
