class AddShouldHaveUserFullProfileToDecidimParticipatoryProcesses < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :should_have_user_full_profile, :boolean, default: false
  end
end
