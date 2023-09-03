
namespace :benchmark_test do
  desc 'Populates database with massive user and proposal related data'
  task seed_database_with_user_proposal_data: :environment do
    user_quantity = 500
    proposals_quantity = 50
    votes_quantity = 10
    comments_quantity = 2

    puts <<~WARNING
    This is going to delete all votes from database before seeding.
    You want to proceed? [Y/n]
    WARNING
    user_confirmation = 'y' # gets

    if user_confirmation.downcase.strip == 'y'

      puts <<~INFO
      ########################################################################################
      Populating database with #{user_quantity} users, #{proposals_quantity} proposals,
      #{votes_quantity} votes per user, #{comments_quantity} comments.
      ########################################################################################
      INFO

      ActiveRecord::Base.transaction do
        organization = Decidim::Organization.first || Decidim::Organization.create!(
          name: Faker::Company.name,
          twitter_handler: Faker::Hipster.word,
          facebook_handler: Faker::Hipster.word,
          instagram_handler: Faker::Hipster.word,
          youtube_handler: Faker::Hipster.word,
          github_handler: Faker::Hipster.word,
          smtp_settings: {
            from: "#{smtp_label} <#{smtp_email}>",
            from_email: smtp_email,
            from_label: smtp_label,
            user_name: ENV.fetch("SMTP_USERNAME", Faker::Twitter.unique.screen_name),
            encrypted_password: Decidim::AttributeEncryptor.encrypt(ENV.fetch("SMTP_PASSWORD", Faker::Internet.password(min_length: 8))),
            address: ENV.fetch("SMTP_ADDRESS", nil) || ENV.fetch("DECIDIM_HOST", "localhost"),
            port: ENV.fetch("SMTP_PORT", nil) || ENV.fetch("DECIDIM_SMTP_PORT", "25")
          },
          host: ENV.fetch("DECIDIM_HOST", "localhost"),
          external_domain_whitelist: ["decidim.org", "github.com"],
          description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
            Decidim::Faker::Localized.sentence(word_count: 15)
          end,
          default_locale: Decidim.default_locale,
          available_locales: Decidim.available_locales,
          reference_prefix: Faker::Name.suffix,
          available_authorizations: Decidim.authorization_workflows.map(&:name),
          users_registration_mode: :enabled,
          tos_version: Time.current,
          badges_enabled: true,
          user_groups_enabled: true,
          send_welcome_notification: true,
          file_upload_settings: Decidim::OrganizationSettings.default(:upload)
        )

        last_user_idx = Decidim::User.last.nickname.split('_').second.to_i + 1

        puts "Populating users..."
        current_time = Time.now
        user_data = user_quantity.times.map do |idx|
          cur_idx = idx + last_user_idx
          {
            email: "user#{cur_idx}@example.com",
            name: "User #{cur_idx}",
            nickname: "user_#{cur_idx}",
            encrypted_password: "OMX*&##*UNIASDLLPOASPMBASE64",
            confirmed_at: Time.current,
            decidim_organization_id: organization.id,
            type: "Decidim::User",
            created_at: current_time,
            updated_at: current_time
          }
        end
        Decidim::User.upsert_all(user_data)

        participatory_space = Decidim::ParticipatoryProcess.last || Decidim::ParticipatoryProcess.create!(
          # TODO
        )

        puts "Populating proposals..."
        proposals_quantity.times do |idx|
          component = Decidim::Component.first || Decidim::Component.create!(
            participatory_space: participatory_space,
            manifest_name: 'proposals',
            name: {'pt' => 'Propostas'}
          )
          proposal = Decidim::Proposals::Proposal.new(
            title: "My little cool Proposal #{idx}",
            body: "This is a dummy proposal body where it's not supposed to be considered valid #{idx} times.",
            component: component,
            published_at: Time.now
          )
          proposal.add_coauthor(
            Decidim::User.find(Decidim::User.pluck(:id).sample),
            user_group: nil
          )
          proposal.save!(validate: false)
        end

        Decidim::Proposals::ProposalVote.find_each do |vote|
          vote.destroy!
        end

        proposals = Decidim::Proposals::Proposal.all
        Decidim::User.find_each do |user|
          proposals.sample(votes_quantity).each do |proposal|
            vote = Decidim::Proposals::ProposalVote.new(
              proposal: proposal,
              author: user
            )
            vote.save!(validate: false)
          end
        end

        users = Decidim::User.last(500)
        comments_quantity.times do |idx|
          proposal = proposals.sample
          comment = Decidim::Comments::Comment.new(
            root_commentable: proposal,
            commentable: proposal,
            author: users.sample,
            body: {"pt" => "This is a legit comment!"}
          )
          comment.save(validate: false)
        end
      end
    end
  end
end