class AddExtraFieldsToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_forms_answers, :extra_fields, :jsonb
  end
end
