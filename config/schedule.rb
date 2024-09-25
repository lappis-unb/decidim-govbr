set :output, "log/cron_log.log"
env :PATH, ENV['PATH']

every :day, at: '00:00am' do
  rake 'decidim:delete_download_your_data_files'
end

every :day, at: '00:05am' do
  rake 'decidim:metrics:all'
end

every :day, at: '00:10am' do
  rake 'decidim:open_data:export'
end

every :day, at: '00:15am' do
  rake 'decidim_meetings:clean_registration_forms'
end

every :day, at: '00:20am' do
  rake 'decidim_initiatives:check_published'
end

every :day, at: '00:25am' do
  rake 'decidim_initiatives:check_validating'
end

every :day, at: '00:30am' do
  rake 'decidim_initiatives:notify_progress'
end

every :day, at: '00:35am' do
  rake 'decidim:reminders:all'
end

every :day, at: '00:40am' do
  rake 'decidim:mailers:notifications_digest_daily'
end

every :saturday, at: '01:00am' do
  rake 'decidim:mailers:notifications_digest_weekly'
end

every :day, at: '01:00am' do
  rake 'decidim:govbr:update_user_proposals_statistics_data'
end

every :day, at: '00:00am' do
  rake 'decidim_participatory_processes:change_active_step'
end