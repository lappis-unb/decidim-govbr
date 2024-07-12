require 'rails_helper'

module Decidim::Admin::ContentBlocks
  describe DestroyContentBlock do
    let!(:organization) { create(:organization) }
    let!(:content_block) { create(:content_block, organization: organization) }

    describe '#call' do
      context 'when the content block exists' do
        it 'destroys the content block successfully' do
          command = described_class.new(content_block)

          expect { command.call }.to change(Decidim::ContentBlock, :count).by(-1)
          expect(command).to broadcast(:ok)
        end
      end

      context 'when the content block does not exist' do
        it 'returns an error message' do
          command = described_class.new(nil)

          expect { command.call }.not_to change(Decidim::ContentBlock, :count)
          expect(command).to broadcast(:invalid)
        end
      end

      context 'when the content block cannot be destroyed' do
        it 'returns an error message' do
          allow(content_block).to receive(:destroy!).and_raise(StandardError)

          command = described_class.new(content_block)

          expect { command.call }.not_to change(Decidim::ContentBlock, :count)
          expect(command).to broadcast(:invalid)
        end
      end
    end
  end
end