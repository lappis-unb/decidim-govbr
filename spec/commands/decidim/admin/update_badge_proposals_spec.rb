# spec/commands/decidim/admin/update_badge_proposals_spec.rb

require 'rails_helper'

module Decidim
  module Admin
    describe UpdateBadgeProposals do
      let(:component) { create(:component, manifest_name: "proposals") }
      let(:user) { create(:user) }
      let!(:proposals) do
        15.times.map do |index|
          create(:proposal, component: component, proposal_votes_count: index + 1)
        end
      end

      describe 'Atualização de Badges' do
        subject { described_class.new(component, user) }

        it 'labels the ten most voted proposals with "Mais Votada"' do
          subject.call

          most_voted_proposals = proposals.sort_by(&:proposal_votes_count).last(10)

          most_voted_proposals.each do |proposal|
            expect(proposal.reload.badge_array).to include("Mais Votada")
          end

          least_voted_proposals = proposals.sort_by(&:proposal_votes_count).first(5)
          least_voted_proposals.each do |proposal|
            expect(proposal.reload.badge_array).not_to include("Mais Votada")
          end
        end

        it 'broadcasts :ok on success' do
          expect(subject).to receive(:broadcast).with(:ok)
          subject.call
        end
      end

      describe 'Inserção de Badges' do
        subject { described_class.new(component, user) }

        describe 'Dez propostas mais votadas' do
          it 'Retorna 10 propostas mais votadas' do
            most_voted_proposals = subject.send(:ten_most_voted_proposals)
            expect(most_voted_proposals.size).to eq(10)
            expect(most_voted_proposals).to match_array(proposals.sort_by(&:proposal_votes_count).last(10))
          end
        end

        describe 'Inserindo na proposta mais votada' do
          let(:proposal) { proposals.first }

          it 'Adiciona o "Mais Votada" no array de badges caso não exista' do
            proposal.badge_array = []
            subject.send(:insert_proposal_most_voted, proposal)
            expect(proposal.reload.badge_array).to include("Mais Votada")
          end

          it 'Não adiciona o "Mais Votada" no array de badges caso já exista' do
            proposal.badge_array = ["Mais Votada"]
            expect(proposal).not_to receive(:update)
            subject.send(:insert_proposal_most_voted, proposal)
          end
        end
      end
    end
  end
end
