class AddParticipatoryGroupReferenceToDecidimUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :decidim_users, :decidim_participatory_process_group, index: true
    add_column :decidim_users, :decidim_participatory_process_group_role, :string
  end
end
