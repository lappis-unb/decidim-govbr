# frozen_string_literal: true

shared_examples_for "partnerable" do
  it { is_expected.to be_partnerable }

  it "return organizers ordered" do
    organizer1 = create(:partner, :as_organizer, partnerable: subject, weight: 100)
    organizer2 = create(:partner, :as_organizer, partnerable: subject, weight: 10)

    expect(subject.organizers).to match_array([organizer2, organizer1])
  end

  it "return supporters ordered" do
    supporter1 = create(:partner, :as_supporter, partnerable: subject, weight: 100)
    supporter2 = create(:partner, :as_supporter, partnerable: subject, weight: 10)

    expect(subject.supporters).to match_array([supporter2, supporter1])
  end

  context "when has multiple associated partners" do
    let!(:partner) { create(:partner, :as_organizer, partnerable: subject) }

    it "destroy them in destruction" do
      expect(subject.partners).to match_array([partner])
      subject.destroy!
      expect(subject.partners).to be_empty
    end
  end
end
