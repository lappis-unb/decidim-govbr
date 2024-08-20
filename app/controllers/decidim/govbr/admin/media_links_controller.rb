# frozen_string_literal: true

module Decidim
  module Govbr
    module Admin
      # Controller that allows managing participatory space media links.
      class MediaLinksController < Decidim::Admin::ApplicationController
        include Decidim::Paginable

        def index
          enforce_permission_to :index, :media_link

          @media_links = paginate(collection)
        end

        def new
          enforce_permission_to :create, :media_link
          @form = form(Decidim::Govbr::Admin::MediaLinkForm).instance
        end

        def create
          enforce_permission_to :create, :media_link
          @form = form(Decidim::Govbr::Admin::MediaLinkForm).from_params(params)

          CreateMediaLink.call(@form, current_user, current_participatory_space) do
            on(:ok) do
              flash[:notice] = I18n.t("media_links.create.success", scope: DECIDIM_ADMIN_SCOPE)
              redirect_to participatory_space_media_links_path(current_participatory_space)
            end

            on(:invalid) do
              flash[:alert] = I18n.t("media_links.create.error", scope: DECIDIM_ADMIN_SCOPE)
              render :new
            end
          end
        end

        def edit
          @media_link = collection.find(params[:id])
          enforce_permission_to :update, :media_link, speaker: @media_link
          @form = form(MediaLinkForm).from_model(@media_link)
        end

        def update
          @media_link = collection.find(params[:id])
          enforce_permission_to :update, :media_link, speaker: @media_link
          @form = form(MediaLinkForm).from_params(params)

          UpdateMediaLink.call(@form, @media_link) do
            on(:ok) do
              flash[:notice] = I18n.t("media_links.update.success", scope: DECIDIM_ADMIN_SCOPE)
              redirect_to participatory_space_media_links_path(current_participatory_space)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("media_links.update.error", scope: DECIDIM_ADMIN_SCOPE)
              render :edit
            end
          end
        end

        def destroy
          @media_link = collection.find(params[:id])
          enforce_permission_to :destroy, :media_link, speaker: @media_link

          DestroyMediaLink.call(@media_link, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("media_links.destroy.success", scope: DECIDIM_ADMIN_SCOPE)
              redirect_to participatory_space_media_links_path(current_participatory_space)
            end
          end
        end

        def participatory_space_media_links_path(_current_participatory_space)
          raise NotImplementedError
        end

        private

        def collection
          @collection ||= current_participatory_space.media_links
        end
      end
    end
  end
end
