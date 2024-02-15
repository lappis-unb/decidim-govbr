class AddCustomInitialPageToProcesses < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :initial_page_type, :string, default: "default", null: false
    add_column :decidim_participatory_processes, :initial_page_component_id, :bigint
  end
end
