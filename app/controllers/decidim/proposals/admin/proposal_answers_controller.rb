# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      # This controller allows admins to answer proposals in a participatory process.
      class ProposalAnswersController < Admin::ApplicationController
        helper_method :proposal

        helper Proposals::ApplicationHelper
        helper Decidim::Proposals::Admin::ProposalsHelper
        helper Decidim::Proposals::Admin::ProposalRankingsHelper
        helper Decidim::Messaging::ConversationHelper

        def edit
          enforce_permission_to :create, :proposal_answer, proposal: proposal
          @form = form(Admin::ProposalAnswerForm).from_model(proposal)
        end

        def update
          enforce_permission_to :create, :proposal_answer, proposal: proposal
          @notes_form = form(ProposalNoteForm).instance
          @answer_form = form(Admin::ProposalAnswerForm).from_params(params)

          Admin::AnswerProposal.call(@answer_form, proposal) do
            on(:ok) do
              flash[:notice] = I18n.t("proposals.answer.success", scope: DECIDIM_PROPOSALS_SCOPE)
              redirect_to proposals_path
            end

            on(:invalid) do
              flash.keep[:alert] = I18n.t("proposals.answer.invalid", scope: DECIDIM_PROPOSALS_SCOPE)
              render template: "decidim/proposals/admin/proposals/show"
            end
          end
        end

        def remove_label_from_proposal
          proposals = Proposal.find(params[:id])
          remove_badge = params[:badge]

          badge_array = proposals.badge_array
          badge_array.delete(remove_badge)
          proposals.update(badge_array: badge_array)

          redirect_to proposal_path(proposals)
        end

        private

        def skip_manage_component_permission
          true
        end

        def proposal
          @proposal ||= Proposal.where(component: current_component).find(params[:id])
        end
      end
    end
  end
end
