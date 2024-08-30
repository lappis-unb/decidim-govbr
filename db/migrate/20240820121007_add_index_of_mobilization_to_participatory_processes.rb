class AddIndexOfMobilizationToParticipatoryProcesses < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :mobilization_position, :integer
  end
end
