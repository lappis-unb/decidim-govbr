# frozen_string_literal: true

require "rails_helper"

describe Decidim::Govbr::AdminLog::PartnerPresenter, type: :helper do
  context "when partnerable is assembly" do
    include_examples "present admin log entry" do
      let(:partnerable) { create(:assembly, organization: organization) }
      let(:admin_log_resource) { create(:partner, :as_organizer, partnerable: partnerable) }
      let(:action) { "delete" }
    end
  end

  context "when partnerable is participatory process" do
    include_examples "present admin log entry" do
      let(:partnerable) { create(:participatory_process, organization: organization) }
      let(:admin_log_resource) { create(:partner, :as_supporter, partnerable: partnerable) }
      let(:action) { "delete" }
    end
  end
end
