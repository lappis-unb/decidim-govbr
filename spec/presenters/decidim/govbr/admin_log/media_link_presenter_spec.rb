# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module AdminLog
      describe MediaLinkPresenter, type: :helper do
        context "when participatory space is participatory process" do
          let(:participatory_space) { create(:participatory_process, organization: organization) }
          let(:admin_log_resource) { create(:govbr_media_link, participatory_space: participatory_space) }
          let(:action) { "delete" }

          include_examples "present admin log entry"
        end

        context "when participatory space is assembly" do
          let(:participatory_space) { create(:assembly, organization: organization) }
          let(:admin_log_resource) { create(:govbr_media_link, participatory_space: participatory_space) }
          let(:action) { "delete" }

          include_examples "present admin log entry"
        end
      end
    end
  end
end
