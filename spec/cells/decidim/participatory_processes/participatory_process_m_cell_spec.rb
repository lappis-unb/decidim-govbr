require "rails_helper"
require "decidim/core/test/shared_examples/space_cell_changes_button_text_cta"

module Decidim::ParticipatoryProcesses
  describe ProcessMCell, type: :cell do
    controller Decidim::ApplicationController
    let(:current_organization) { create(:organization) }
    let(:model) { create(:participatory_process) }

    subject { cell("decidim/participatory_processes/process_m", model) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(subject.call).to have_css(".card--component")
      end

      it_behaves_like "space cell changes button text CTA"
    end

    describe "#badge" do
      context "when has_badge? is true" do
        before do
          allow(subject).to receive(:has_badge?).and_return(true)
        end

        it "renders the badge" do
          expect(subject.badge).not_to be_nil
        end
      end

      context "when has_badge? is false" do
        before do
          allow(subject).to receive(:has_badge?).and_return(false)
        end

        it "does not render the badge" do
          expect(subject.badge).to be_nil
        end
      end
    end

    describe "#description" do
      it "returns a truncated description" do
        description = "This is a very long description that should be truncated to a shorter version"
        allow(model).to receive(:description).and_return(description)
        expect(subject.send(:description)).to eq("This is a very long description that should be truncated to a shorter version")
      end
    end

    describe "#has_image?" do
      it "returns true" do
        expect(subject.send(:has_image?)).to be(true)
      end
    end

    describe "#has_state?" do
      context "when the process is past" do
        before do
          allow(model).to receive(:past?).and_return(true)
        end

        it "returns true" do
          expect(subject.send(:has_state?)).to be(true)
        end
      end

      context "when the process is not past" do
        before do
          allow(model).to receive(:past?).and_return(false)
        end

        it "returns false" do
          expect(subject.send(:has_state?)).to be(false)
        end
      end
    end

    describe "#state" do
      context "when the process is past_result?" do
        before do
          allow(model).to receive(:past_result?).and_return(true)
        end

        it "returns 'finished'" do
          expect(subject.send(:state)).to eq(I18n.t("decidim.participatory_processes.card.status.finished"))
        end
      end

      context "when the process is upcoming?" do
        before do
          allow(model).to receive(:upcoming?).and_return(true)
        end

        it "returns 'upcoming'" do
          expect(subject.send(:state)).to eq(I18n.t("decidim.participatory_processes.card.status.upcoming"))
        end
      end

      context "when the process is past?" do
        before do
          allow(model).to receive(:past?).and_return(true)
        end

        it "returns 'closed'" do
          expect(subject.send(:state)).to eq(I18n.t("decidim.participatory_processes.card.status.closed"))
        end
      end

      context "when the process is active" do
        before do
          allow(model).to receive(:active?).and_return(true)
        end

        it "returns 'active'" do
          expect(subject.send(:state)).to eq(I18n.t("decidim.participatory_processes.card.status.active"))
        end
      end
    end

    describe "#state_classes" do
      context "when the process is past_result?" do
        before do
          allow(model).to receive(:past_result?).and_return(true)
        end

        it "returns ['green']" do
          expect(subject.send(:state_classes)).to eq(["green"])
        end
      end

      context "when the process is active?" do
        before do
          allow(model).to receive(:active?).and_return(true)
        end

        it "returns ['blue']" do
          expect(subject.send(:state_classes)).to eq(["blue"])
        end
      end

      context "when the process is past?" do
        before do
          allow(model).to receive(:past?).and_return(true)
          allow(model).to receive(:past_result?).and_return(false)
          allow(model).to receive(:active?).and_return(false)
          allow(model).to receive(:upcoming?).and_return(false)
        end

        it "returns ['red']" do
          expect(subject.send(:state_classes)).to eq(["red"])
        end
      end

      context "when the process is upcoming?" do
        before do
          allow(model).to receive(:upcoming?).and_return(true)
          allow(model).to receive(:past?).and_return(false)
          allow(model).to receive(:past_result?).and_return(false)
          allow(model).to receive(:active?).and_return(false)
        end

        it "returns ['orange']" do
          expect(subject.send(:state_classes)).to eq(["orange"])
        end
      end
    end

    describe "#resource_path" do
      it "returns the correct path" do
        expect(subject.send(:resource_path)).to eq(Decidim::ParticipatoryProcesses::Engine.routes.url_helpers.participatory_process_path(model))
      end
    end

    describe "#resource_image_path" do
      it "returns the correct image path" do
        expect(subject.send(:resource_image_path)).to eq(model.attached_uploader(:hero_image).path)
      end
    end
  end
end
