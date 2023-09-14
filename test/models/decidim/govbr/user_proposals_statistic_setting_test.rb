require 'test_helper'

module Decidim
  module Govbr
    class UserProposalsStatisticSettingTest < ActiveSupport::TestCase
      setup do
        @org = Decidim::Organization.new(
          name: 'brasil participativo',
          host: 'localhost:3000',
          default_locale: 'pt-BR',
          available_locales: ['en', 'pt-BR'],
          reference_prefix: 'org1'
        )
        @org.save!(validate: false)

        @participatory_process1 = Decidim::ParticipatoryProcess.new(
          slug: 'ppa',
          title: 'PPA participativo do Brasil',
          subtitle: 'PPA participativo',
          short_description: 'PPA participativo',
          description: 'PPA participativo do Brasil',
          organization: @org
        )
        @participatory_process1.save!(validate: false)

        @component1 = Decidim::Component.new(
          name: 'proposals 1',
          participatory_space: @participatory_process1,
          manifest_name: 'proposals'
        )
        @component1.save!(validate: false)

        @user1 = Decidim::User.new(
          email: "user1@example.com",
          name: "User 1",
          nickname: "user_1",
          password: "OMX*&##*UNIASDLLPOASPMBASE64",
          password_confirmation: "OMX*&##*UNIASDLLPOASPMBASE64",
          confirmed_at: Time.current,
          decidim_organization_id: @org.id,
          type: "Decidim::User",
        )
        @user1.save!(validate: false)

        @cpf1 = Decidim::Identity.new(
          provider: 'govbr',
          uid: 'cpf1',
          decidim_user_id: @user1.id
        )
        @cpf1.save!(validate: false)

        @user2 = Decidim::User.new(
          email: "user2@example.com",
          name: "User 2",
          nickname: "user_2",
          password: "OMX*&##*UNIASDLLPOASPMBASE64",
          password_confirmation: "OMX*&##*UNIASDLLPOASPMBASE64",
          confirmed_at: Time.current,
          decidim_organization_id: @org.id,
          type: "Decidim::User",
        )
        @user2.save!(validate: false)

        @cpf2 = Decidim::Identity.new(
          provider: 'govbr',
          uid: '',
          decidim_user_id: @user2.id
        )
        @cpf2.save!(validate: false)

        @user3 = Decidim::User.new(
          email: "user3@example.com",
          name: "User 3",
          nickname: "user_3",
          password: "OMX*&##*UNIASDLLPOASPMBASE64",
          password_confirmation: "OMX*&##*UNIASDLLPOASPMBASE64",
          confirmed_at: Time.current,
          decidim_organization_id: @org.id,
          type: "Decidim::User",
        )
        @user3.save!(validate: false)

        @participatory_process2 = Decidim::ParticipatoryProcess.new(
          slug: 'ppb',
          title: 'PPB participativo do Brasil',
          subtitle: 'PPB participativo',
          short_description: 'PPB participativo',
          description: 'PPB participativo do Brasil',
          organization: @org
        )
        @participatory_process2.save!(validate: false)

        @component2 = Decidim::Component.new(
          name: 'proposals 2',
          participatory_space: @participatory_process2,
          manifest_name: 'proposals'
        )
        @component2.save!(validate: false)

        @proposal1 = Decidim::Proposals::Proposal.new(
          title: 'proposal 1 user 1',
          body: 'this is the user 1 proposal 1',
          component: @component1,
          published_at: Time.current
        )
        @proposal1.add_coauthor(
          Decidim::User.first,
          user_group: nil
        )
        @proposal1.save!(validate: false)

        @proposal2 = Decidim::Proposals::Proposal.new(
          title: 'proposal 2 user 1',
          body: 'this is the user 2 proposal 1',
          component: @component1,
          published_at: Time.current
        )
        @proposal2.add_coauthor(
          Decidim::User.first,
          user_group: nil
        )
        @proposal2.save!(validate: false)

        @proposal3 = Decidim::Proposals::Proposal.new(
          title: 'proposal 1 user 2',
          body: 'this is the user 1 proposal 2',
          component: @component1,
          published_at: Time.current
        )
        @proposal3.add_coauthor(
          Decidim::User.second,
          user_group: nil
        )
        @proposal3.save!(validate: false)

        @proposal4 = Decidim::Proposals::Proposal.new(
          title: 'proposal 2 user 2',
          body: 'this is the user 2 proposal 2',
          component: @component2,
          published_at: Time.current
        )
        @proposal4.add_coauthor(
          Decidim::User.second,
          user_group: nil
        )
        @proposal4.save!(validate: false)

        Decidim::User.find_each do |user|
          Decidim::Proposals::Proposal.find_each do |proposal|
            vote = Decidim::Proposals::ProposalVote.new(
              proposal: proposal,
              author: user
            )
            vote.save!(validate: false)

            comment = Decidim::Comments::Comment.new(
              root_commentable: proposal,
              commentable: proposal,
              author: user,
              body: {"pt" => "this is a comment"}
            )
            comment.save!(validate: false)
          end
        end

        @user4 = Decidim::User.new(
          email: "user4@example.com",
          name: "User 4",
          nickname: "user_4",
          password: "OMX*&##*UNIASDLLPOASPMBASE64",
          password_confirmation: "OMX*&##*UNIASDLLPOASPMBASE64",
          confirmed_at: Time.current,
          decidim_organization_id: @org.id,
          type: "Decidim::User",
        )
        @user4.save!(validate: false)

        @user5 = Decidim::User.new(
          email: "user5@example.com",
          name: "User 5",
          nickname: "user_5",
          password: "OMX*&##*UNIASDLLPOASPMBASE64",
          password_confirmation: "OMX*&##*UNIASDLLPOASPMBASE64",
          confirmed_at: Time.current,
          decidim_organization_id: @org.id,
          type: "Decidim::User",
        )
        @user5.save!(validate: false)

        @user6 = Decidim::User.new(
          email: "user6@example.com",
          name: "User 6",
          nickname: "user_6",
          password: "OMX*&##*UNIASDLLPOASPMBASE64",
          password_confirmation: "OMX*&##*UNIASDLLPOASPMBASE64",
          confirmed_at: Time.current,
          decidim_organization_id: @org.id,
          type: "Decidim::User",
        )
        @user6.save!(validate: false)

        Decidim::Proposals::Proposal.find_each do |proposal|
          vote = Decidim::Proposals::ProposalVote.new(
            proposal: proposal,
            author: @user4
          )
          vote.save!(validate: false)

          comment = Decidim::Comments::Comment.new(
            root_commentable: proposal,
            commentable: proposal,
            author: @user5,
            body: {"pt" => "this is a comment"}
          )
          comment.save!(validate: false)

          follow = Decidim::Follow.new(
            user: @user6,
            followable: proposal
          )
          follow.save!(validate: false)
        end
      end

      test 'should only consider proposals data from the registered participatory space' do
        setting = Decidim::Govbr::UserProposalsStatisticSetting.create(
          decidim_participatory_space_type: @participatory_process1.class.to_s,
          decidim_participatory_space_id: @participatory_process1.id,
          name: 'relatorio'
        )
        assert_equal 4, Decidim::Proposals::Proposal.count
        assert_equal 16, Decidim::Comments::Comment.count
        assert_equal 8, Decidim::Follow.count

        setting.refresh_data!
        setting.reload

        statistic = setting.user_proposals_statistics.where(decidim_user_id: @user1.id).first
        assert_equal @user1.name, statistic.decidim_user_name
        assert_equal 2, statistic.proposals_done
        assert_equal 3, statistic.comments_done
        assert_equal 3, statistic.votes_done
        assert_equal 2, statistic.follows_done
        assert_equal 8, statistic.votes_received
        assert_equal 8, statistic.comments_received
        assert_equal 4, statistic.follows_received

        expected_score = statistic.proposals_done + statistic.comments_done + statistic.votes_done + statistic.follows_done + statistic.votes_received + statistic.comments_received + statistic.follows_received
        assert_equal expected_score.to_f, statistic.score

        statistic = setting.user_proposals_statistics.where(decidim_user_id: @user2.id).first
        assert_equal @user2.name, statistic.decidim_user_name
        assert_equal 1, statistic.proposals_done
        assert_equal 3, statistic.comments_done
        assert_equal 3, statistic.votes_done
        assert_equal 1, statistic.follows_done
        assert_equal 4, statistic.votes_received
        assert_equal 4, statistic.comments_received
        assert_equal 2, statistic.follows_received

        expected_score = statistic.proposals_done + statistic.comments_done + statistic.votes_done + statistic.follows_done + statistic.votes_received + statistic.comments_received + statistic.follows_received
        assert_equal expected_score.to_f, statistic.score

        statistic = setting.user_proposals_statistics.where(decidim_user_id: @user3.id).first
        assert_equal @user3.name, statistic.decidim_user_name
        assert_equal 0, statistic.proposals_done
        assert_equal 3, statistic.comments_done
        assert_equal 3, statistic.votes_done
        assert_equal 0, statistic.follows_done
        assert_equal 0, statistic.votes_received
        assert_equal 0, statistic.comments_received
        assert_equal 0, statistic.follows_received

        expected_score = statistic.proposals_done + statistic.comments_done + statistic.votes_done + statistic.follows_done + statistic.votes_received + statistic.comments_received + statistic.follows_received
        assert_equal expected_score.to_f, statistic.score

        statistic = setting.user_proposals_statistics.where(decidim_user_id: @user4.id).first
        assert_equal @user4.name, statistic.decidim_user_name
        assert_equal 0, statistic.proposals_done
        assert_equal 0, statistic.comments_done
        assert_equal 3, statistic.votes_done
        assert_equal 0, statistic.follows_done
        assert_equal 0, statistic.votes_received
        assert_equal 0, statistic.comments_received
        assert_equal 0, statistic.follows_received

        expected_score = statistic.proposals_done + statistic.comments_done + statistic.votes_done + statistic.follows_done + statistic.votes_received + statistic.comments_received + statistic.follows_received
        assert_equal expected_score.to_f, statistic.score

        statistic = setting.user_proposals_statistics.where(decidim_user_id: @user5.id).first
        assert_equal @user5.name, statistic.decidim_user_name
        assert_equal 0, statistic.proposals_done
        assert_equal 3, statistic.comments_done
        assert_equal 0, statistic.votes_done
        assert_equal 0, statistic.follows_done
        assert_equal 0, statistic.votes_received
        assert_equal 0, statistic.comments_received
        assert_equal 0, statistic.follows_received

        expected_score = statistic.proposals_done + statistic.comments_done + statistic.votes_done + statistic.follows_done + statistic.votes_received + statistic.comments_received + statistic.follows_received
        assert_equal expected_score.to_f, statistic.score

        statistic = setting.user_proposals_statistics.where(decidim_user_id: @user6.id).first
        assert_equal @user6.name, statistic.decidim_user_name
        assert_equal 0, statistic.proposals_done
        assert_equal 0, statistic.comments_done
        assert_equal 0, statistic.votes_done
        assert_equal 3, statistic.follows_done
        assert_equal 0, statistic.votes_received
        assert_equal 0, statistic.comments_received
        assert_equal 0, statistic.follows_received

        expected_score = statistic.proposals_done + statistic.comments_done + statistic.votes_done + statistic.follows_done + statistic.votes_received + statistic.comments_received + statistic.follows_received
        assert_equal expected_score.to_f, statistic.score
      end

      test 'should keep data from other participatory space untouched after refreshing' do
        setting = Decidim::Govbr::UserProposalsStatisticSetting.create!(decidim_participatory_space_type: 'foo', decidim_participatory_space_id: 1)
        statistics = 5.times.map do |index|
          Decidim::Govbr::UserProposalsStatistic.create!(user_proposals_statistic_setting: setting, decidim_user_id: index, decidim_user_name: "User #{index}", decidim_user_identification_number: "CPF #{index}")
        end

        setting = Decidim::Govbr::UserProposalsStatisticSetting.create!(
          decidim_participatory_space_type: @participatory_process1.class.to_s,
          decidim_participatory_space_id: @participatory_process1.id,
          name: 'relatorio'
        )

        assert_empty setting.user_proposals_statistics

        setting.refresh_data!

        statistics.each do |statistic|
          assert statistic.persisted?
        end

        refute_empty setting.reload.user_proposals_statistics
      end

      test 'should build csv content correctly' do
        setting = Decidim::Govbr::UserProposalsStatisticSetting.create(
          decidim_participatory_space_type: @participatory_process1.class.to_s,
          decidim_participatory_space_id: @participatory_process1.id,
          name: 'relatorio'
        )
        Decidim::Govbr::UserProposalsStatistic.create!(
          user_proposals_statistic_setting: setting,
          decidim_user_id: 1,
          decidim_user_name: "User 1",
          decidim_user_identification_number: "CPF",
          proposals_done: 10,
          comments_done: 17,
          votes_done: 5,
          follows_done: 21,
          votes_received: 58,
          comments_received: 12,
          follows_received: 34,
          score: 105.0
        )

        expected_header = Decidim::Govbr::UserProposalsStatistic.csv_attributes_header_map.values.join(',')
        expected_content = [1, 'User 1', 10, 17, 5, 21, 58, 12, 34, 105.0].join(',')

        header, content = setting.user_proposals_statistics_as_csv.split("\n")
        assert_equal expected_header, header
        assert_equal expected_content, content
      end
    end
  end
end