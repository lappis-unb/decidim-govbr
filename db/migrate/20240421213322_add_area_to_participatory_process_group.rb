class AddAreaToParticipatoryProcessGroup < ActiveRecord::Migration[6.1]
  def change
    add_reference :decidim_participatory_process_groups, :decidim_area, index: true, foreign_key: true
  end
end
