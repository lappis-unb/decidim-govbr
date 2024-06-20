class ChangeDecidimUsersNotificationDefaultColumnValues < ActiveRecord::Migration[6.1]
  def change
    change_column_default :decidim_users, :notification_types, "all"
    change_column_default :decidim_users, :newsletter_notifications_at, Time.current
    change_column_default :decidim_users, :direct_message_types, "all"
    change_column_default :decidim_users, :email_on_moderations, true
    change_column_default :decidim_users, :notification_settings, {"close_meeting_reminder"=>"1"}
  end
end
