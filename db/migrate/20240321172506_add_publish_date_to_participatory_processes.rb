class AddPublishDateToParticipatoryProcesses < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :publish_date, :date
  end
end
