# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Proposals
    module Admin
      describe ParticipatoryTextsController, type: :controller do
        routes { Decidim::Proposals::AdminEngine.routes }
        
        let(:user) { create(:user, :confirmed, :admin, organization: component.organization) }
        let(:component) { create :proposal_component, :with_participatory_texts_enabled }
        

        before do
          request.env["decidim.current_organization"] = component.organization
          request.env["decidim.current_component"] = component
          sign_in user
        end

        describe "POST import" do
          let(:document_file) { upload_test_file(Decidim::Dev.asset("participatory_text.md"), content_type: "text/markdown") }
          let(:title) { { en: ::Faker::Book.title } }
          let(:params) do
            {
              component_id: component.id,
              initiative_slug: "",
              participatory_process_slug: component.participatory_space.slug,
              title: title,
              description: {},
              document: document_file
            }
          end

          context "when the command fails" do
            let(:title) { {} }

            it "returns 422 status and displays the alert message" do
              post :import, params: params

              expect(response).to have_http_status(:unprocessable_entity)
              expect(flash[:alert]).to eq("The form is invalid!")
            end
          end

          context "when the command succeeds" do
            it "parses the document" do
              post :import, params: params
              expect(response).to redirect_to EngineRouter.admin_proxy(component).participatory_texts_path
              expect(flash[:notice].starts_with?("Congratulations")).to be true
            end
          end
        end

        # describe "POST update_as_preview" do

        #   let(:proposal) { create(:proposal, component: component) }
        #   let(:proposal2) { create(:proposal, component: component) }
        #   let(:proposals_attributes) do
        #     [
        #       {
        #         id: proposal.id,
        #         title: "Updated Proposal",
        #         body: "Updated body",
        #         position: 1,
        #         is_interactive: true,
        #         deleted: false
        #       },
        #       {
        #         id: proposal2.id,
        #         title: "New Proposal",
        #         body: "New body",
        #         position: 2,
        #         is_interactive: true,
        #         deleted: false
        #       }
        #     ]
        #   end

        #   context "when the command succeeds" do
        #     it "redirects to edit_as_preview if proposal_to_add is present" do
        #       post :update_as_preview, params: {
        #         component_id: component.id,
        #         initiative_slug: "",
        #         preview_participatory_text: {
        #           proposals_attributes: proposals_attributes,
        #           proposal_to_add: ""
        #         }
        #       }
        #       expect(response).to redirect_to(edit_as_preview_participatory_texts_path)
        #       expect(flash[:notice]).to eq(I18n.t("participatory_texts.update.success", scope: "decidim.proposals.admin"))
        #     end
      
        #     it "redirects to proposals_path if proposal_to_add is not present" do
        #       post "/admin/participatory_texts/update_as_preview", params: {
        #         preview_participatory_text: {
        #           proposals_attributes: proposals_attributes,
        #           proposal_to_add: "article"
        #         },
        #         component_id: component.id,
        #         initiative_slug: ""
        #       }
        #       expect(response).to redirect_to(proposals_path)
        #       expect(flash[:notice]).to eq(I18n.t("participatory_texts.update.success", scope: "decidim.proposals.admin"))
        #     end
        #   end
      
        #   context "when the command fails" do
        #     it "displays the alert message" do
        #       allow(PublishParticipatoryText).to receive(:call).and_yield(double(:result, on: nil)).and_return(on: nil, invalid: { 1 => "error" })
      
        #       post "/participatory_texts/update_as_preview", params: {
        #         preview_participatory_text:
        #         {proposals_attributes: proposals_attributes,
        #         proposal_to_add: "article"},
        #         component_id: component.id,
        #         initiative_slug: ""
        #       }
        #       expect(flash[:alert]).to include("ID:[1] error")
        #     end
        #   end
        # end
      
      end
    end
  end
end
