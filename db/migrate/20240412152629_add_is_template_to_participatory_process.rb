class AddIsTemplateToParticipatoryProcess < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :is_template, :boolean, default: false, null: false
  end
end
