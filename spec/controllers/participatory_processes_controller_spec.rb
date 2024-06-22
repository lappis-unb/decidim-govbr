# frozen_string_literal: true

require "rails_helper"
require "decidim/dev/test/promoted_participatory_processes_shared_examples"

module Decidim
  module ParticipatoryProcesses
    describe ParticipatoryProcessesController, type: :controller do
      let(:organization) { create(:organization) }
      let!(:unpublished_process) do
        create(
          :participatory_process,
          :unpublished,
          organization: organization
        )
      end

      let(:meeting_component) { create(:component, manifest_name: "meetings", participatory_space: unpublished_process) }
      let!(:meetings) { create_list(:meeting, 2, :published, component: meeting_component) }

      before do
        request.env["decidim.current_organization"] = organization
      end

      describe "with engine routes" do
        routes { Decidim::ParticipatoryProcesses::Engine.routes }

        describe "published_processes" do
          it "includes only published participatory processes" do
            published = create_list(
              :participatory_process,
              2,
              :published,
              organization: organization
            )

            expect(controller.helpers.participatory_processes.count).to eq(2)
            expect(controller.helpers.participatory_processes.to_a).to include(published.first)
            expect(controller.helpers.participatory_processes.to_a).to include(published.last)
            expect(controller.helpers.participatory_processes.to_a).not_to include(unpublished_process)
          end

          it "redirects to 404 if there aren't any" do
            expect { get :index }.to raise_error(ActionController::RoutingError)
          end
        end

        include_examples "with promoted participatory processes and groups"

        describe "collection" do
          let(:other_organization) { create(:organization) }

          it "includes a heterogeneous array of processes and groups" do
            published = create_list(
              :participatory_process,
              2,
              :published,
              organization: organization
            )

            _unpublished = create_list(
              :participatory_process,
              2,
              :unpublished,
              organization: organization
            )

            organization_groups = create_list(
              :participatory_process_group,
              2,
              :with_participatory_processes,
              organization: organization
            )

            _other_groups = create_list(
              :participatory_process_group,
              2,
              :with_participatory_processes,
              organization: other_organization
            )

            _manipulated_other_groups = create(
              :participatory_process_group,
              participatory_processes: [create(:participatory_process, organization: organization)]
            )

            expect(controller.helpers.collection)
              .to match_array([*published, *organization_groups])
          end
        end

        describe "default_date_filter" do
          let!(:active) { create(:participatory_process, :published, :active, organization: organization) }
          let!(:upcoming) { create(:participatory_process, :published, :upcoming, organization: organization) }
          let!(:past) { create(:participatory_process, :published, :past, organization: organization) }

          it "defaults to active if there are active published processes" do
            expect(controller.helpers.default_date_filter).to eq("active")
          end

          it "defaults to upcoming if there are upcoming (but no active) published processes" do
            active.update(published_at: nil)
            expect(controller.helpers.default_date_filter).to eq("upcoming")
          end

          it "defaults to past if there are past (but no active nor upcoming) published processes" do
            active.update(published_at: nil)
            upcoming.update(published_at: nil)
            expect(controller.helpers.default_date_filter).to eq("past")
          end
        end

        describe "GET show" do
          context "when the process is unpublished" do
            it "redirects to sign in path" do
              get :show, params: { slug: unpublished_process.slug }

              expect(response).to redirect_to("/users/sign_in")
            end

            context "with signed in user" do
              let!(:user) { create(:user, :confirmed, organization: organization) }

              before do
                sign_in user, scope: :user
              end

              it "redirects to root path" do
                get :show, params: { slug: unpublished_process.slug }

                expect(response).to redirect_to("/")
              end
            end
          end
        end

        describe "GET statistics" do
          let!(:active) { create(:participatory_process, :published, :active, organization: organization) }

          before do
            request.env["decidim.current_organization"] = organization
          end

          context "when the process can show statistics" do
            it "shows them" do
              get :all_metrics, params: { slug: active.slug }

              expect(response).to be_successful
            end
          end

          context "when the process cannot show statistics" do
            it "does not show them" do
              active.update!(show_statistics: false)
              get :all_metrics, params: { slug: active.slug }

              expect(response).to be_not_found
            end
          end
        end
      end

      describe "with main routes" do
        describe "GET all_meetings_of_a_participatory_process" do
          let!(:active) { create(:participatory_process, :published, :active, organization: organization) }
          let!(:meetings) { create_list(:meeting, 2, :published, component: meeting_component) }

          context "when no search term is provided" do
            it "returns all meetings of the participatory process" do
              get :all_meetings_of_a_participatory_process, params: { slug: unpublished_process.slug, state: meetings.first.associated_state }

              expect(response).to be_successful
              parsed_response = JSON.parse(response.body)
              expect(parsed_response.size).to eq(2)
              expect(parsed_response.map { |m| m["id"] }).to include(meetings.first.id, meetings.last.id)
            end
          end

          context "when a search term is provided" do
            it "returns only the meetings matching the search term" do
              meeting = meetings.first
              meeting.update!(title: { "pt-BR" => "Reunião de Teste" })

              get :all_meetings_of_a_participatory_process, params: { slug: unpublished_process.slug, state: meeting.associated_state, search: "Teste" }

              expect(response).to be_successful
              parsed_response = JSON.parse(response.body)
              expect(parsed_response.size).to eq(1)
              expect(parsed_response.first["id"]).to eq(meeting.id)
            end
          end

          context "when filtering by state" do
            it "returns only the meetings with the specified state" do
              meeting = meetings.first
              meeting.update!(associated_state: 3)

              get :all_meetings_of_a_participatory_process, params: { slug: unpublished_process.slug, state: 3 }

              expect(response).to be_successful
              parsed_response = JSON.parse(response.body)
              expect(parsed_response.size).to eq(1)
              expect(parsed_response.first["id"]).to eq(meeting.id)
            end
          end
        end
      end
    end
  end
end
