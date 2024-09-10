# frozen_string_literal: true

module Decidim
  module Proposals
    # Exposes the proposal resource so users can view and create them.
    class ProposalsController < Decidim::Proposals::ApplicationController
      helper Decidim::WidgetUrlsHelper
      helper ProposalWizardHelper
      helper ParticipatoryTextsHelper
      helper UserGroupHelper
      include Decidim::ApplicationHelper
      include Flaggable
      include Withdrawable
      include FormFactory
      include FilterResource
      include Decidim::Proposals::Orderable
      include Paginable
      include Decidim::Govbr::ParticipatoryProcessesHelper
      include Decidim::Proposals

      helper_method :proposal_presenter, :form_presenter

      before_action :authenticate_user!, only: [:new, :create, :complete]
      before_action :ensure_is_draft, only: [:compare, :complete, :preview, :publish, :edit_draft, :update_draft, :destroy_draft]
      before_action :set_proposal, only: [:show, :edit, :update, :destroy, :preview, :withdraw]
      before_action :edit_form, only: [:edit_draft, :edit]

      before_action :set_participatory_text
      before_action :display_user_profile_poll_warning, only: [:index, :show]

      # rubocop:disable Naming/VariableNumber
      # rubocop:enable Naming/VariableNumber

      def index
        if component_settings.participatory_texts_enabled?
          load_participatory_texts
        else
          load_proposals
        end
      end

      def show
        raise ActionController::RoutingError, "Not Found" if @proposal.blank? || !can_show_proposal?
      end

      def new
        enforce_permission_to :create, :proposal

        @form = form(ProposalForm).instance
      end

      def create
        enforce_permission_to :create, :proposal
        @form = form(ProposalForm).from_params(proposal_creation_params)
        @form.attachment = form_attachment_new

        CreateProposal.call(@form, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("proposals.create.success", scope: "decidim")

            if params[:proposal][:should_preview] == "preview"
              flash[:notice] = I18n.t("proposals.create.success", scope: "decidim")
              redirect_to "#{Decidim::ResourceLocatorPresenter.new(proposal).path}/preview"
            else
              PublishProposal.call(@proposal, current_user) do
                on(:ok) do
                  if @proposal.reload.hidden?
                    flash[:notice] =
                      "Sua #{translated_attribute(@proposal.component.singular_name || {})} foi criada com sucesso. No momento ela está sendo avaliada, e assim que for aprovada ela aparecerá publicamente."
                  else
                    flash[:notice] = I18n.t("proposals.publish.success", scope: "decidim")
                  end

                  redirect_to proposal_path(@proposal)
                end

                on(:invalid) do
                  handle_error(:invalid, "Erro ao publicar sua proposta.")
                  redirect_to proposal_path(@proposal)
                end
              end
            end
          end
          on(:invalid) { handle_error(:invalid, "Erro ao criar proposta. Verifique os campos obrigatórios.") }
          on(:attachment_invalid) { handle_error(:attachment_invalid, "Erro ao criar proposta. Anexo inválido.") }
          on(:limit_reached) { handle_error(:limit_reached, "Erro ao criar proposta. Você chegou ao limite da criação de propostas.") }
        end
      end

      # def compare
      #   enforce_permission_to :edit, :proposal, proposal: @proposal
      #   @similar_proposals ||= Decidim::Proposals::SimilarProposals
      #                          .for(current_component, @proposal)
      #                          .all

      #   if @similar_proposals.blank?
      #     flash[:notice] = I18n.t("proposals.proposals.compare.no_similars_found", scope: "decidim")
      #     redirect_to "#{Decidim::ResourceLocatorPresenter.new(@proposal).path}/complete"
      #   end
      # end

      # def complete
      #   enforce_permission_to :edit, :proposal, proposal: @proposal

      #   @form = form_proposal_model

      #   @form.attachment = form_attachment_new
      # end

      def preview
        @proposal = Proposal.find(params[:id])
        enforce_permission_to :edit, :proposal, proposal: @proposal
      end

      def publish
        enforce_permission_to :edit, :proposal, proposal: @proposal

        PublishProposal.call(@proposal, current_user) do
          on(:ok) do
            redirect_to proposal_path(@proposal)
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.publish.error", scope: "decidim")
            render :edit_draft
          end
        end
      end

      def edit_draft
        enforce_permission_to :edit, :proposal, proposal: @proposal
      end

      def update_draft
        enforce_permission_to :edit, :proposal, proposal: @proposal
        @form = form_proposal_params

        UpdateProposal.call(@form, current_user, @proposal) do
          on(:ok) do |proposal|
            flash[:notice] = I18n.t("proposals.update_draft.success", scope: "decidim")
            redirect_to "#{Decidim::ResourceLocatorPresenter.new(proposal).path}/preview"
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.update_draft.error", scope: "decidim")
            render :edit_draft
          end
        end
      end

      def destroy_draft
        enforce_permission_to :edit, :proposal, proposal: @proposal

        DestroyProposal.call(@proposal, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("proposals.destroy_draft.success", scope: "decidim")
            redirect_to new_proposal_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.destroy_draft.error", scope: "decidim")
            render :edit_draft
          end
        end
      end

      def edit
        enforce_permission_to :edit, :proposal, proposal: @proposal
      end

      def update
        enforce_permission_to :edit, :proposal, proposal: @proposal

        @form = form_proposal_params

        UpdateProposal.call(@form, current_user, @proposal) do
          on(:ok) do |proposal|
            flash[:notice] = I18n.t("proposals.update.success", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(proposal).path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.update.error", scope: "decidim")
            render :edit
          end
        end
      end

      def withdraw
        enforce_permission_to :withdraw, :proposal, proposal: @proposal

        WithdrawProposal.call(@proposal, current_user) do
          on(:ok) do
            flash[:sucess] = I18n.t("proposals.withdraw.success", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path
          end
          on(:has_supports) do
            flash[:alert] = I18n.t("proposals.withdraw.errors.has_supports", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path
          end
        end
      end

      private

      def load_participatory_texts
        @proposals = fetch_participatory_texts
        render "decidim/proposals/proposals/participatory_texts/participatory_text"
      end

      def load_proposals
        @base_query = search.result.published.not_hidden
        @proposals = fetch_proposals
        @all_geocoded_proposals = @base_query.geocoded
        @voted_proposals = fetch_voted_proposals
        @user_proposals_statistic = fetch_user_proposals_statistic
      end

      def fetch_proposals
        proposals = @base_query.includes(:component, :coauthorships, :attachments)
        proposals = reorder(proposals)
        paginate(proposals)
      end

      def fetch_participatory_texts
        Decidim::Proposals::Proposal
          .where(component: current_component)
          .published
          .not_hidden
          .only_amendables
          .includes(:category, :scope, :attachments, :coauthorships)
          .order(position: :asc)
      end

      def fetch_voted_proposals
        return [] unless current_user

        ProposalVote.where(author: current_user, proposal: @proposals.pluck(:id)).pluck(:decidim_proposal_id)
      end

      def fetch_user_proposals_statistic
        return unless current_user

        Decidim::Govbr::UserProposalsStatistic.by_component(current_component).by_user(current_user).take rescue nil
      end

      def handle_error(event, message)
        flash.now[event] = message
        render :new
      end

      def search_collection
        Proposal.where(component: current_component).published.not_hidden.with_availability(params[:filter].try(:[], :with_availability))
      end

      def default_filter_params
        {
          search_text_cont: "",
          with_any_origin: default_filter_origin_params,
          activity: "all",
          with_any_category: default_filter_category_params,
          with_any_state: %w(accepted partially_accepted rejected evaluating state_not_published disqualified),
          with_any_scope: default_filter_scope_params,
          related_to: "",
          type: "all"
        }
      end

      def default_filter_origin_params
        filter_origin_params = %w(participants meeting)
        filter_origin_params << "official" if component_settings.official_proposals_enabled
        filter_origin_params << "user_group" if current_organization.user_groups_enabled?
        filter_origin_params
      end

      def proposal_draft
        Proposal.from_all_author_identities(current_user).not_hidden.only_amendables
                .where(component: current_component).find_by(published_at: nil)
      end

      def ensure_is_draft
        @proposal = Proposal.not_hidden.where(component: current_component).find(params[:id])
        redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path unless @proposal.draft?
      end

      def set_proposal
        @proposal = Proposal.find(params[:id])
      end

      # Returns true if the proposal is NOT an emendation or the user IS an admin.
      # Returns false if the proposal is not found or the proposal IS an emendation
      # and is NOT visible to the user based on the component's amendments settings.
      def can_show_proposal?
        return true if @proposal&.amendable? || current_user&.admin?

        Proposal.only_visible_emendations_for(current_user, current_component).published.include?(@proposal)
      end

      def proposal_presenter
        @proposal_presenter ||= present(@proposal)
      end

      def form_proposal_params
        form(ProposalForm).from_params(params)
      end

      def form_proposal_model
        form(ProposalForm).from_model(@proposal)
      end

      def form_presenter
        @form_presenter ||= present(@form, presenter_class: Decidim::Proposals::ProposalPresenter)
      end

      def form_attachment_new
        form(AttachmentForm).from_model(Attachment.new)
      end

      def edit_form
        form_attachment_model = form(AttachmentForm).from_model(@proposal.attachments.first)
        @form = form_proposal_model
        @form.attachment = form_attachment_model
        @form
      end

      def set_participatory_text
        @participatory_text = Decidim::Proposals::ParticipatoryText.find_by(component: current_component)
      end

      def translated_proposal_body_template
        translated_attribute component_settings.new_proposal_body_template
      end

      def proposal_creation_params
        params[:proposal].merge(body_template: translated_proposal_body_template)
      end

      def display_user_profile_poll_warning
        return unless current_participatory_space.is_a? Decidim::ParticipatoryProcess

        if current_participatory_space.should_have_user_full_profile && current_user.present? &&
           !current_user.user_profile_poll_answered
          survey_component_id = current_organization.user_profile_survey_id

          flash[:alert] = I18n.t("decidim.components.proposals.actions.action_not_allowed")
          flash[:poll_link] = mount_user_profile_survey_url(survey_id: survey_component_id)
        end
      end
    end
  end
end
