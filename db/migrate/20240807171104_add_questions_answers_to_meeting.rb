class AddQuestionsAnswersToMeeting < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_forms_questions, :decidim_meetings_meeting_id, :integer
    add_column :decidim_forms_answers, :decidim_meetings_meeting_id, :integer
    add_foreign_key :decidim_forms_questions, :decidim_meetings_meetings
    add_foreign_key :decidim_forms_answers, :decidim_meetings_meetings
  end
end
