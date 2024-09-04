module Decidim
  module Admin
    class ProposalBadgesController < Decidim::Admin::ApplicationController
      helper_method :manifest, :current_participatory_space

      def index
        component_id = params[:id]
        @component = Decidim::Component.find(component_id)
        @user = current_user
      end

      def update
        component_id = params[:current_component]
        @component = Decidim::Component.find(component_id)

        if @component.settings.most_voted_rule.zero?
          flash.now[:alert] = "Não foi possível atualizar os rótulos. Insira quantas propostas você deseja que tenham o rótulo Mais Votada."
          redirect_to request.referer
        else
          UpdateBadgeProposals.call(@component, @user) do
            on(:ok) do
              flash[:notice] = "Atualização bem-sucedida!"
              redirect_to request.referer
            end

            on(:invalid) do
              flash.now[:alert] = "Ocorreu um erro ao atualizar os rótulos."
              redirect_to request.referer
            end
          end
        end
      end

      def update_proposal_badge
        proposal_id = params[:proposal_id]
        badge_name = params[:badge_id]

        UpdateOneProposalBadge.call(@component, proposal_id, badge_name, @user) do
          on(:ok) do
            flash[:notice] = "Atualização bem-sucedida!"
            redirect_to request.referer
          end

          on(:invalid) do
            flash.now[:alert] = "Ocorreu um erro ao atualizar o rótulo."
            redirect_to request.referer
          end
        end
      end

      def destroy_all_badges
        component_id = params[:component_id]
        @component = Decidim::Component.find(component_id)

        DestroyBadgeProposals.call(@component, @user) do
          on(:ok) do
            flash[:notice] = "Rótulo excluído com sucesso!"
            redirect_to request.referer
          end

          on(:invalid) do
            flash.now[:alert] = "Ocorreu um erro ao excluir o rótulo."
            redirect_to request.referer
          end
        end
      end

      def destroy_one_badge
        proposal_id = params[:proposal_id]
        badge_name = params[:badge_id]

        DestroyOneProposalBadge.call(@component, proposal_id, badge_name, @user) do
          on(:ok) do
            flash[:notice] = "Rótulo excluído com sucesso!"
            redirect_to request.referer
          end

          on(:invalid) do
            flash.now[:alert] = "Ocorreu um erro ao excluir o rótulo."
            redirect_to request.referer
          end
        end
      end

      private

      def proposal_badge_params
        params.require(:proposal_badge).permit(:name, :description) # Ajuste conforme seus parâmetros
      end
    end
  end
end
