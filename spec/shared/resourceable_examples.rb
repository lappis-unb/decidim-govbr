# frozen_string_literal: true

shared_examples_for "resourceable" do
  describe "resource_title" do
    it "is defined" do
      expect(subject.resource_title).to be_present
    end
  end
end
