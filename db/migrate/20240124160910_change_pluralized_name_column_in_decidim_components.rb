class ChangePluralizedNameColumnInDecidimComponents < ActiveRecord::Migration[6.1]
  def change
    rename_column :decidim_components, :pluralized_name, :singular_name
  end
end
