class ChangeUserProfilePollLinkInDecidimOrganizations < ActiveRecord::Migration[6.1]
  def change
    rename_column :decidim_organizations, :user_profile_poll_link, :user_profile_survey_id
    change_column :decidim_organizations, :user_profile_survey_id, 'integer USING user_profile_survey_id::integer'
  end
end
