class ChangeDefaultAllNotificationsFromUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :decidim_users, :notification_types, from: 'all', to: 'none'
    change_column_default :decidim_users, :direct_message_types, from: 'all', to: 'followed-only'
    change_column_default :decidim_users, :email_on_moderations, from: true, to: false
    change_column_default :decidim_users, :notification_settings, from: {}, to: { "close_meeting_reminder": "0" }
  end
end
