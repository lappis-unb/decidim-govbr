require 'rails_helper'
require 'shared/component_context'
require 'shared/accessibility_examples'
require 'support/geocoder'

# frozen_string_literal: true

describe "Proposals", type: :system do
  include ActionView::Helpers::TextHelper
  include GeocoderHelpers
  include Decidim::ComponentPathHelper
  include TranslateHelper
  include_context "with a component"
  let(:manifest_name) { "proposals" }

  let!(:category) { create :category, participatory_space: participatory_process }
  let!(:scope) { create :scope, organization: organization }
  let!(:user) do
    create :user, :admin,
           :confirmed, password: "l2WxBHWsVW535MtrCqi3",
                       password_confirmation: "l2WxBHWsVW535MtrCqi3",
                       email: "example@email.com",
                       organization: organization
  end
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization: organization, scope: scope) }

  let(:address) { "Some address" }
  let(:latitude) { 40.1234 }
  let(:longitude) { 2.1234 }

  let(:proposal_title) { translated(proposal.title) }

  matcher :have_author do |name|
    match { |node| node.has_selector?(".author-data", text: name) }
    match_when_negated { |node| node.has_no_selector?(".author-data", text: name) }
  end

  matcher :have_creation_date do |date|
    match { |node| node.has_selector?(".author-data__extra", text: date) }
    match_when_negated { |node| node.has_no_selector?(".author-data__extra", text: date) }
  end

  context "when viewing a single proposal" do
    let!(:component) do
      create(:proposal_component,
             manifest: manifest,
             participatory_space: participatory_process,
             settings: {
               scopes_enabled: true,
               scope_id: participatory_process.scope&.id
             })
    end

    let!(:proposals) { create_list(:proposal, 3, component: component) }
    let!(:proposal) { proposals.first }

    it "allows viewing a single proposal" do
      page.visit decidim.new_user_session_path(locale: :'pt-BR')

      fill_in "E-mail", with: "example@email.com"
      fill_in "Senha", with: "l2WxBHWsVW535MtrCqi3"

      click_button("Conecte-se")

      expect(page).to have_content("Olá,")
    end
  end
end
