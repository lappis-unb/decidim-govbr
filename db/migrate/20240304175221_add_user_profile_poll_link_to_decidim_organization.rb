class AddUserProfilePollLinkToDecidimOrganization < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_organizations, :user_profile_survey_id, :integer
  end
end
