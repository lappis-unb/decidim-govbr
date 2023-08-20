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
    end
  end
end