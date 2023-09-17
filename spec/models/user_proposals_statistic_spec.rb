require 'rails_helper'

RSpec.describe Decidim::Govbr::UserProposalsStatistic, type: :model do
  describe '.by_component' do
    let! (:setting) {
      FactoryBot.create(:user_proposals_statistic_setting, :with_5_statistics)
    }

    let (:statistics) {
      setting.user_proposals_statistics
    }

    context 'when component can be mapped into a setting' do
      let (:component) {
        Decidim::Component.new(
          manifest_name: 'proposals',
          participatory_space_type: setting.decidim_participatory_space_type,
          participatory_space_id: setting.decidim_participatory_space_id
        )
      }

      it 'should return all statistics' do
        expect(Decidim::Govbr::UserProposalsStatistic.by_component(component)).to match_array(statistics)
      end
    end

    context 'when component cannot be mapped into a setting' do
      let (:component) {
        Decidim::Component.new(
          manifest_name: 'proposals',
          participatory_space_type: 'Fake::Participatory::Space',
          participatory_space_id: 0
        )
      }

      it 'should return blank data' do
        expect(Decidim::Govbr::UserProposalsStatistic.by_component(component)).to be_empty
      end
    end

    context 'when component is not a Decidim::Component' do
      it 'should raise an exception' do
        expect { Decidim::Govbr::UserProposalsStatistic.by_component('1') }.to raise_error
      end
    end
  end

  describe '.by_user' do
    let! (:user) {
      FactoryBot.create(:user, :confirmed)
    }

    let! (:setting) {
      FactoryBot.create(
        :user_proposals_statistic_setting,
        user_proposals_statistics: [
          FactoryBot.build(:user_proposals_statistic, decidim_user_id: user.id),
          FactoryBot.build(:user_proposals_statistic, decidim_user_id: user.id + 1)
        ]
      )
    }

    context 'when user has a statistic' do
      it { expect(Decidim::Govbr::UserProposalsStatistic.by_user(user).first).to eq(setting.user_proposals_statistics.first) }
    end

    context 'when user has not a statistic' do
      it { expect(Decidim::Govbr::UserProposalsStatistic.by_user(Decidim::User.new(id: user.id + 2))).to be_empty }
    end

    context 'when user is not a decidim user' do
      it { expect { Decidim::Govbr::UserProposalsStatistic.by_user('admin@example.com') }.to raise_error }
    end

    context '.by_component' do
      context 'if user statistic is owned by the specified component' do
        let (:component) {
          Decidim::Component.new(
            manifest_name: 'proposals',
            participatory_space_type: setting.decidim_participatory_space_type,
            participatory_space_id: setting.decidim_participatory_space_id
          )
        }

        it {
          statistics = Decidim::Govbr::UserProposalsStatistic.by_user(user).by_component(component)
          expect(statistics).to match_array([setting.user_proposals_statistics.first])
        }
      end

      context 'if user statistic is NOT owned by the specified component' do
        let (:component) {
          Decidim::Component.new(
            manifest_name: 'proposals',
            participatory_space_type: 'Fake::Participatory::Space',
            participatory_space_id: 0
          )
        }

        it {
          expect(Decidim::Govbr::UserProposalsStatistic.by_user(user).by_component(component)).to be_empty
        }
      end
    end
  end

  describe '.csv_attributes_header_map' do
    it {
      expected_hash = {
        'decidim_user_id' => 'ID do Usuário',
        'decidim_user_name' => 'Nome',
        'proposals_done' => 'Propostas criadas',
        'comments_done' => 'Comentários feitos em propostas',
        'votes_done' => 'Votos dados em propostas',
        'follows_done' => 'Propostas que segue',
        'votes_received' => 'Votos recebidos em suas propostas',
        'comments_received' => 'Comentários recebidos em suas propostas',
        'follows_received' => 'Seguidores em suas propostas',
        'score' => 'Pontuação total'
      }
      expect(Decidim::Govbr::UserProposalsStatistic.csv_attributes_header_map).to eq(expected_hash)
    }
  end
end
