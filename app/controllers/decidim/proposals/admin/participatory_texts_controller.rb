# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      # This controller manages the participatory texts area.
      class ParticipatoryTextsController < Admin::ApplicationController
        helper_method :proposal
        helper ParticipatoryTextsHelper

        def index
          @drafts = Proposal.where(component: current_component).drafts.order(:position)
          @preview_form = form(Admin::PreviewParticipatoryTextForm).instance
          @preview_form.from_models(@drafts)
        end

        def new_import
          enforce_permission_to :manage, :participatory_texts
          participatory_text = Decidim::Proposals::ParticipatoryText.find_by(component: current_component)
          @import = form(Admin::ImportParticipatoryTextForm).from_model(participatory_text)
        end

        def set_flash_and_redirect(message_key, path)
          flash[:notice] = I18n.t(message_key, scope: DECIDIM_PROPOSALS_SCOPE)
          redirect_to path
        end

        def handle_validation_failures(failures, action)
          alert_msg = [I18n.t("participatory_texts.publish.invalid", scope: DECIDIM_PROPOSALS_SCOPE)]
          failures.each_pair { |id, msg| alert_msg << "ID:[#{id}] #{msg}" }
          flash.now[:alert] = alert_msg.join("<br/>").html_safe
          send(action)
        end

        def import
          enforce_permission_to :manage, :participatory_texts
          @import = form(Admin::ImportParticipatoryTextForm).from_params(params)

          Admin::ImportParticipatoryText.call(@import) do
            on(:ok) do
              set_flash_and_redirect("participatory_texts.import.success", EngineRouter.admin_proxy(current_component).participatory_texts_path)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("participatory_texts.import.invalid", scope: DECIDIM_PROPOSALS_SCOPE)
              render action: "new_import", status: :unprocessable_entity
            end

            on(:invalid_file) do
              flash.now[:alert] = I18n.t("participatory_texts.import.invalid_file", scope: DECIDIM_PROPOSALS_SCOPE)
              render action: "new_import", status: :unprocessable_entity
            end
          end
        end

        # When `save_draft` param exists, proposals are only saved.
        # When no `save_draft` param is set, proposals are saved and published.
        def update
          enforce_permission_to :manage, :participatory_texts

          form_params = params.require(:preview_participatory_text).permit!
          @preview_form = form(Admin::PreviewParticipatoryTextForm).from_params(proposals: form_params[:proposals_attributes]&.values, proposal_to_add: form_params[:proposal_to_add])

          if params[:save_draft].present?
            UpdateParticipatoryText.call(@preview_form) do
              on(:ok) do
                set_flash_and_redirect("participatory_texts.update.success", EngineRouter.admin_proxy(current_component).participatory_texts_path)
              end

              on(:invalid) do |failures|
                handle_validation_failures(failures, "index")
              end
            end
          else
            PublishParticipatoryText.call(@preview_form) do
              on(:ok) do
                set_flash_and_redirect("participatory_texts.publish.success", proposals_path)
              end

              on(:invalid) do |failures|
                handle_validation_failures(failures, "index")
              end
            end
          end
        end

        def update_as_preview
          enforce_permission_to :manage, :participatory_texts
          form_params = params.require(:preview_participatory_text).permit!

          @preview_form = form(Admin::PreviewParticipatoryTextForm).from_params(proposals: form_params[:proposals_attributes]&.values, proposal_to_add: form_params[:proposal_to_add])

          PublishParticipatoryText.call(@preview_form) do
            on(:ok) do
              if form_params[:proposal_to_add].present?
                set_flash_and_redirect("participatory_texts.update.success", EngineRouter.admin_proxy(current_component).edit_as_preview_participatory_texts_path)
              else
                set_flash_and_redirect("participatory_texts.update.success", proposals_path)
              end
            end

            on(:invalid) do |failures|
              alert_msg = [I18n.t("participatory_texts.publish.invalid", scope: DECIDIM_PROPOSALS_SCOPE)]
              failures.each_pair { |id, msg| alert_msg << "ID:[#{id}] #{msg}" }
              flash.now[:alert] = alert_msg.join("<br/>").html_safe
              edit_as_preview
            end
          end
        end

        def edit_as_preview
          enforce_permission_to :manage, :participatory_texts

          @participatory_texts = Proposal.where(component: current_component).order(:position)

          @preview_form = form(Admin::PreviewParticipatoryTextForm).instance
          @preview_form.from_models(@participatory_texts)
        end

        # Removes all the unpublished proposals (drafts).
        def discard
          enforce_permission_to :manage, :participatory_texts

          DiscardParticipatoryText.call(current_component) do
            on(:ok) do
              set_flash_and_redirect("participatory_texts.discard.success", EngineRouter.admin_proxy(current_component).participatory_texts_path)
            end
          end
        end
      end
    end
  end
end
