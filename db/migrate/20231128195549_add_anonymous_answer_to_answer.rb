class AddAnonymousAnswerToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_forms_answers, :anonymous_answer, :boolean, default: true
  end
end
