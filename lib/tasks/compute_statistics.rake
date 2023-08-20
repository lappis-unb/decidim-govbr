
# query = <<-SQL
#   SELECT
#     follows_count as seguidores_do_usuario

#   FROM decidim_users as usr
#   WHERE usr.decidim_organization_id = #{organization_id};
# SQL

# top_users = []
# Decidim::User.where(organization: org).find_each(bach_size: 10000) do |user|

#   # SELECT DISTINCT coauthorable_id
#   # WHERE decidim_author_id IN $()

#   # SELECT couathorable_id
#   # FROM decidim_coauthorships as cauth
#   # INNER JOIN decidim_users as usr
#   #   ON cauth.decidim_author_id = usr.id
#   # WHERE coauthorable_type = 'Decidim::Proposals::Proposal'
#   #   AND usr.decidim_organization_id = ?
#   # ORDER BY usr.id;

#   # E se existirem coauthorships duplicados?
#   #

#   # SELECT usr.id, usr.name, SUM(prop.proposal_votes_count), SUM(prop.comments_count), SUM(prop.follows_count)
#   # FROM decidim_coauthorships as cauth
#   # INNER JOIN decidim_users as usr
#   #   ON cauth.decidim_author_id = usr.id
#   # INNER JOIN decidim_proposals_proposals as prop
#   #   ON cauth.coauthorable_id = prop.id
#   # WHERE coauthorable_type = 'Decidim::Proposals::Proposal'
#   #   AND usr.decidim_organization_id = ?
#   # GROUP BY usr.id;

# query_user_proposal_stats = <<-SQL.squish
#   SELECT usr.id as user_id, usr.name as user_name COUNT(prop.id) as proposals_done, SUM(prop.proposal_votes_count) as votes_received, SUM(prop.comments_count) as comments_received, SUM(prop.follows_count) as follows_received
#   FROM decidim_coauthorships as cauth
#   INNER JOIN decidim_users as usr
#     ON cauth.decidim_author_id = usr.id
#   INNER JOIN decidim_proposals_proposals as prop
#     ON cauth.coauthorable_id = prop.id
#   WHERE coauthorable_type = 'Decidim::Proposals::Proposal'
#     AND usr.decidim_organization_id = 1
#   GROUP BY usr.id
# SQL

# query_user_comment_stats = <<-SQL.squish
#   SELECT usr.id as user_id, COUNT(cmt.id) as comments_done
#   FROM decidim_users as usr
#   INNER JOIN decidim_comments_comments as cmt
#     ON cmt.decidim_author_id = usr.id
#   WHERE cmt.commentable_type = 'Decidim::Proposals::Proposal'
#     AND usr.decidim_organization_id = 1
#   GROUP BY usr.id;
# SQL

# query_user_votes_stats = <<-SQL.squish
#   SELECT usr.id as user_id, COUNT(pv.id) as votes_done
#   FROM decidim_users as usr
#   INNER JOIN decidim_proposals_proposal_votes as pv
#     ON pv.decidim_author_id = usr.id
#   WHERE usr.decidim_organization_id = 1
#   GROUP BY usr.id;
# SQL

# query_user_follow_stats <<-SQL.squish
#   SELECT usr.id as user_id, COUNT(f.id) as follows_done
#   FROM decidim_users as usr
#   INNER JOIN decidim_follows as f
#     ON f.decidim_user_id = usr.id
#   WHERE f.followable_type = 'Decidim::Proposals::Proposal'
#     AND usr.decidim_organization_id = 1
#   GROUP BY usr.id;
# SQL

# final_query = <<-SQL.squish
#   SELECT  ps.user_id
#           ps.user_name
#           ps.proposals_done,
#           ps.votes_received,
#           ps.comments_received,
#           ps.follows_received,
#           cs.comments_done,
#           vs.votes_dones,
#           fs.follows_done,
#           SUM()
#   FROM (#{query_user_proposal_stats}) as ps
#   INNER JOIN (#{query_user_comment_stats}) as cs
#     ON ps.user_id = cs.user_id
#   INNER JOIN (#{query_user_votes_stats}) as vs
#     ON ps.user_id = vs.user_id
#   INNER JOIN (#{query_user_follow_stats}) as fs
#     ON ps.user_id = fs.user_id;
# SQL

#   user_proposals = Decidim::Coauthorship.
#     where(decidim_author_id: user.id, coauthorable_type: 'Decidim::Proposals::Proposal').
#     map(&:coauthorable).
#     uniq()

#   user_proposals_count = Decidim::Proposals::ProposalVote.where(proposal: user_proposals).count

#   proposal_statistics = user_proposals.reduce { |p|
#     {
#       'follows_count': p.follows_count,
#       'comments_count': p.comments_count,
#       'endorsements_count': p.endorsements_count,

#     }.with_indifferent_access
#   }

#   user_data = {}
#   map { |p| {comments: p.comments_count, follows: p.follows_count, endorsements: p.e
#     ndorsements_count} }

#   top_users << user_data
# end

# top_users.sort

# ActiveRecord::Base::exec_command.to_ary()