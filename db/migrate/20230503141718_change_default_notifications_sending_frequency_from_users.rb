class ChangeDefaultNotificationsSendingFrequencyFromUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :decidim_users, :notifications_sending_frequency, from: 'daily', to: 'none'
  end
end
