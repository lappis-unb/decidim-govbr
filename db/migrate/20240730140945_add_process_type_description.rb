class AddProcessTypeDescription < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_process_types, :description, :jsonb
  end
end
