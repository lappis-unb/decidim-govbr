# frozen_string_literal: true

require "rails_helper"

module Decidim
  module Govbr
    module Admin
      describe DestroyPartner do
        subject { described_class.new(partner, current_user) }

        let!(:partnerable) { create :participatory_process }
        let(:partner) { create :partner, :as_supporter, partnerable: partnerable }
        let!(:current_user) { create :user, :confirmed, organization: partnerable.organization }

        context "when partner is passed to be destroyed" do
          it "destroy the partner" do
            expect { subject.call }.to broadcast(:ok)
            expect(partner).not_to be_persisted
          end
        end
      end
    end
  end
end