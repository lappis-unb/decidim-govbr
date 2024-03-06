class AddProcessDataFieldsToDecidimParticipatoryProcesses < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :institution, :string
    add_column :decidim_participatory_processes, :sector, :string
    add_column :decidim_participatory_processes, :process_status, :integer, default: 0
    add_column :decidim_participatory_processes, :consultant, :string
    add_column :decidim_participatory_processes, :dou_publication_date, :date
    add_column :decidim_participatory_processes, :dou_link, :string
    add_column :decidim_participatory_processes, :contact, :string
  end
end
