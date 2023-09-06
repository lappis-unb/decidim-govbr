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
          uid: 'cpf2',
          decidim_user_id: @user2.id
        )
        @cpf2.save!(validate: false)

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
      end

      test 'should only consider proposals data from the registered participatory space' do
        setting = Decidim::Govbr::UserProposalsStatisticSetting.create(
          decidim_participatory_space_type: @participatory_process1.class.to_s,
          decidim_participatory_space_id: @participatory_process1.id,
          name: 'relatorio'
        )
        assert_equal 4, Decidim::Proposals::Proposal.count
        assert_equal 8, Decidim::Comments::Comment.count
        assert_equal 4, Decidim::Follow.count

        setting.refresh_data!
        setting.reload

        statistic = setting.user_proposals_statistics.where(decidim_user_id: @user1.id).first
        assert_equal 2, statistic.proposals_done
        assert_equal 3, statistic.comments_done
        assert_equal 3, statistic.votes_done
        assert_equal 2, statistic.follows_done
        assert_equal 4, statistic.votes_received
        assert_equal 4, statistic.comments_received
        assert_equal 2, statistic.follows_received
        assert_equal @cpf1.uid, statistic.decidim_user_identification_number

        expected_score = statistic.proposals_done + statistic.comments_done + statistic.votes_done + statistic.follows_done + statistic.votes_received + statistic.comments_received + statistic.follows_received
        assert_equal expected_score.to_f, statistic.score

        statistic = setting.user_proposals_statistics.where(decidim_user_id: @user2.id).first
        assert_equal 1, statistic.proposals_done
        assert_equal 3, statistic.comments_done
        assert_equal 3, statistic.votes_done
        assert_equal 1, statistic.follows_done
        assert_equal 2, statistic.votes_received
        assert_equal 2, statistic.comments_received
        assert_equal 1, statistic.follows_received
        assert_equal @cpf2.uid, statistic.decidim_user_identification_number

        expected_score = statistic.proposals_done + statistic.comments_done + statistic.votes_done + statistic.follows_done + statistic.votes_received + statistic.comments_received + statistic.follows_received
        assert_equal expected_score.to_f, statistic.score
      end
    end
  end
end