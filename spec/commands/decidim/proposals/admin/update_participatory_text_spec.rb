# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Proposals
    module Admin
      describe UpdateParticipatoryText do
        include TranslateHelper
        describe "call" do
          let(:organization) { create :organization }
          let(:participatory_space) { create :participatory_process, organization: organization }
          let(:current_component) do
            create(
              :proposal_component,
              participatory_space: participatory_space
            )
          end
          let(:proposals) do
            proposals = create_list(:proposal, 3, component: current_component)
            proposals.each_with_index do |proposal, idx|
              level = Decidim::Proposals::ParticipatoryTextSection::LEVELS.keys[idx]
              proposal.update(participatory_text_level: level)
              proposal.versions.destroy_all
            end
            proposals
          end
          let(:proposal_modifications) do
            modifs = []
            new_positions = [3, 1, 2]
            proposals.each do |proposal|
              modifs << Decidim::Proposals::Admin::ParticipatoryTextProposalForm.new(
                id: proposal.id,
                position: new_positions.shift,
                title: ::Faker::Books::Lovecraft.fhtagn,
                body: { en: ::Faker::Books::Lovecraft.fhtagn(number: 5) },
                is_interactive: false
              ).with_context(
                current_participatory_space: current_component.participatory_space,
                current_component: current_component
              )
            end
            modifs
          end
          let(:form) do
            instance_double(
              PreviewParticipatoryTextForm,
              current_component: current_component,
              proposals: proposal_modifications,
              invalid?: false,
              should_create_new_proposal?: false
            )
          end
          let(:command) { described_class.new(form) }

          it "does not create a version for each proposal", versioning: true do
            expect { command.call }.to broadcast(:ok)

            proposals.each do |proposal|
              expect(proposal.reload.versions.count).to be_zero
            end
          end

          describe "when form modifies proposals" do
            context "with valid values" do
              it "persists modifications" do
                expect { command.call }.to broadcast(:ok)
                proposals.zip(proposal_modifications).each do |proposal, proposal_form|
                  proposal.reload
                  expect(proposal_form.title).to eq translated(proposal.title)
                  expect(proposal_form.body).to eq translated(proposal.body) if proposal.participatory_text_level == Decidim::Proposals::ParticipatoryTextSection::LEVELS[:article]
                  expect(proposal_form.position).to eq proposal.position
                  expect(proposal_form.is_interactive).to eq proposal.is_interactive
                end
              end
            end

            context "with invalid values" do
              before do
                proposal_modifications.each { |proposal_form| proposal_form.title = "" }
              end

              it "does not persist modifications and broadcasts invalid" do
                failures = {}
                proposals.each do |proposal|
                  failures[proposal.id] = ["Proposal Title can't be blank"]
                end
                expect { command.call }.to broadcast(:invalid, failures)
              end
            end
          end

          context "when preview form is invalid" do
            let(:form) do
              instance_double(
                PreviewParticipatoryTextForm,
                current_component: current_component,
                proposals: [],
                invalid?: true
              )
            end

            it "broadcasts invalid" do
              expect { command.call }.to broadcast(:invalid)
            end
          end

          context "when form pushes a new proposal" do
            let(:current_user) { create :user, :confirmed, :admin, organization: organization }
            let(:form) do
              instance_double(
                PreviewParticipatoryTextForm,
                current_component: current_component,
                proposals: [],
                proposal_to_add: "section",
                invalid?: false,
                should_create_new_proposal?: true,
                current_user: current_user
              )
            end
            let(:last_proposal) { Decidim::Proposals::Proposal.last }

            it "creates a new proposal" do
              expect { command.call }.to change(Decidim::Proposals::Proposal, :count).by(1)
            end

            it "create a new proposal with pre filled title" do
              I18n.with_locale(:'pt-BR') do
                command.call
                expect(last_proposal.title["pt-BR"]).to eq("Seção")
              end
            end
          end

          context "when proposal is marked to be destroyed" do
            let!(:proposal) { proposals.first }
            let(:proposal_modifications) do
              Array.wrap(
                Decidim::Proposals::Admin::ParticipatoryTextProposalForm.new(
                  id: proposal.id,
                  position: proposal.position,
                  title: ::Faker::Books::Lovecraft.fhtagn,
                  body: { en: ::Faker::Books::Lovecraft.fhtagn(number: 5) },
                  is_interactive: false,
                  deleted: true
                ).with_context(
                  current_participatory_space: current_component.participatory_space,
                  current_component: current_component
                )
              )
            end

            it "deletes the proposal" do
              expect { command.call }.to change(Decidim::Proposals::Proposal, :count).by(-1)
              expect { proposal.reload }.to raise_error(ActiveRecord::RecordNotFound)
            end
          end
        end
      end
    end
  end
end
