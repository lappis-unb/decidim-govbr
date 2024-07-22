class AddExtraFieldsToDecidimParticipatoryProcess < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_participatory_processes, :extra_fields, :jsonb
  end
end
