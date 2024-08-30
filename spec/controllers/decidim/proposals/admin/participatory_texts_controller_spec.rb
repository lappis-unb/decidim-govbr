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
      end
    end
  end
end
