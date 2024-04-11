class AddShowMobilization < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :show_mobilization, :boolean
  end
end
