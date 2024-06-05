# frozen_string_literal: true

require "rails_helper"

shared_examples_for "space cell changes button text CTA" do
  describe "within the card footer" do
    context "when it has no components" do
      it "renders 'Participate' in the CTA button text" do
        expect(subject.call).to have_selector(".component_buttons .card__button", text: "Participate")
      end
    end

    context "when it has a component" do
      context "and it is not published" do
        let!(:component) { create(:component, :unpublished, manifest_name: "dummy", participatory_space: model) }

        it "renders 'Participate' in the CTA button text" do
          expect(subject.call).to have_selector(".component_buttons .card__button", text: "Participate")
        end
      end

      context "and it is published" do
        let!(:component) { create(:component, :published, manifest_name: "dummy", participatory_space: model) }

        it "renders 'Take part' in the CTA button text" do
          expect(subject.call).to have_selector(".component_buttons .card__button", text: "Participate")
        end
      end
    end
  end
end
