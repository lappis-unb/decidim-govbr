class AddUserProfilePollAnsweredToDecidimUser < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_users, :user_profile_poll_answered, :boolean, default: false
  end
end
