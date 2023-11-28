class AddToppFieldsToQuestionnaires < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_forms_questionnaires, :topp, :jsonb
    add_column :decidim_forms_questionnaires, :collect_user_data, :boolean, default: false
  end
end
