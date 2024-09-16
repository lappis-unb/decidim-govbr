require 'rails_helper'

module Decidim::Admin::ContentBlocks
  describe CreateContentBlock do
    subject { described_class.new(organization, scope, manifest_name, scoped_resource_id) }

    let(:organization) { create(:organization) }
    let(:scope) { 'homepage' }
    let(:manifest_name) { 'html' }
    let(:scoped_resource_id) { nil }

    it 'creates a content block' do
      expect { subject.call }.to change(Decidim::ContentBlock, :count).by(1)
    end

    it 'broadcasts :ok' do
      expect { subject.call }.to broadcast(:ok)
    end

    context 'when an error occurs' do
      before { allow(Decidim::ContentBlock).to receive(:create!).and_raise(StandardError) }

      it 'broadcasts :invalid' do
        expect { subject.call }.to broadcast(:invalid)
      end
    end
  end
end