# frozen_string_literal: true

shared_examples "has media links" do
  context "when have multiple media links" do
    let!(:media_link) { create(:govbr_media_link, participatory_space: subject) }

    it "destroys the associated media link in cascade" do
      expect(subject.media_links).to match_array([media_link])
      subject.destroy!
      expect(subject.media_links).to be_empty
      expect { media_link.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end