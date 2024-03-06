# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Admin
    module Govbr
      describe AutofillOrganizationMenuLinks do
        let(:user) { create(:user, :admin, :confirmed, organization: organization) }
        let(:organization) { create(:organization) }
        let(:command) { described_class.new(user) }
        let!(:assembly) { create(:assembly, :published , organization:organization) }
        let!(:process) { create(:participatory_process, :published, organization:organization) }
        let!(:private_assembly) { create(:assembly, :published, :private ,organization:organization) }
        let!(:private_processes) { create(:participatory_process, :published, :private , organization:organization) }
        let!(:unpublished_assembly) { create(:assembly, :unpublished, organization:organization) }
        let!(:unpublished_processes) { create(:participatory_process, :unpublished, organization:organization) }
        let!(:process_proposals) { create(:proposal_component, participatory_space:process) }

        context "when there are unpublished and private participatory spaces" do
          it "only consider published and public participatory spaces" do
            command.call

            expect(organization.menu_links).to eq(
              {
                "menu" => [
                  {
                    "id" => "processes_#{process.id}",
                    "label" => process.title['pt'],
                    "sub_items" => [
                      {
                        "id" => "processes_#{process_proposals.id}",
                        "label" => process_proposals.name["pt"],
                        "href" => "/processes/#{process.slug}/f/#{process_proposals.id}",
                        "is_visible" => true
                      }
                    ],
                    "is_visible" => true
                  },
                  {
                    "id" => "assemblies_#{assembly.id}",
                    "label" => assembly.title['pt'],
                    "sub_items" => [],
                    "is_visible" => true
                  }
                ]
              }
            )
          end
        end
      end
    end
  end
end
