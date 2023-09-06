# frozen_string_literal: true

module Decidim
  module Govbr
    # User Statistic is a table compiling all user activity numbers when it comes to interacting with proposals.
    # This table is also detached from Decidim main project, which means it could be destroyed and manipulated
    # with no big concerns.
    # I.e. with detached it means: no direct relashionship with Decidim tables or constraints.
    class UserProposalsStatistic < ApplicationRecord
      self.table_name = 'decidim_govbr_user_proposals_statistics'

      belongs_to :user_proposals_statistic_setting, class_name: 'Decidim::Govbr::UserProposalsStatisticSetting'

      def self.csv_attributes_header_map
        [
          ['decidim_user_id', 'ID do Usuário'],
          ['decidim_user_identification_number', 'CPF'],
          ['decidim_user_name', 'Nome'],
          ['proposals_done', 'Propostas criadas'],
          ['comments_done', 'Comentários feitos em propostas'],
          ['votes_done', 'Votos dados em propostas'],
          ['follows_done', 'Propostas que segue'],
          ['votes_received', 'Votos recebidos em suas propostas'],
          ['comments_received', 'Comentários recebidos em suas propostas'],
          ['follows_received', 'Seguidores em suas propostas'],
          ['score', 'Pontuação total']
        ]
      end
    end
  end
end