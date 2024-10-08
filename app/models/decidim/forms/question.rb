# frozen_string_literal: true

module Decidim
  module Forms
    # The data store for a Question in the Decidim::Forms component.
    class Question < Forms::ApplicationRecord
      include Decidim::TranslatableResource

      QUESTION_TYPES = %w(short_answer long_answer single_option multiple_option sorting files matrix_single matrix_multiple).freeze
      SEPARATOR_TYPE = "separator"
      TITLE_AND_DESCRIPTION_TYPE = "title_and_description"
      TYPES = (QUESTION_TYPES + [SEPARATOR_TYPE, TITLE_AND_DESCRIPTION_TYPE]).freeze

      translatable_fields :body, :description

      belongs_to :questionnaire, class_name: "Questionnaire", foreign_key: "decidim_questionnaire_id"

      has_many :matrix_rows,
               class_name: "QuestionMatrixRow",
               foreign_key: "decidim_question_id",
               dependent: :destroy,
               inverse_of: :question

      has_many :answer_options,
               class_name: "AnswerOption",
               foreign_key: "decidim_question_id",
               dependent: :destroy,
               inverse_of: :question

      # Conditions to display this question in questionnaire
      has_many :display_conditions,
               class_name: "DisplayCondition",
               foreign_key: "decidim_question_id",
               dependent: :destroy,
               inverse_of: :question

      # Conditions to display other questions based on the value of this question's answer
      has_many :display_conditions_for_other_questions,
               class_name: "DisplayCondition",
               foreign_key: "decidim_condition_question_id",
               dependent: :destroy,
               inverse_of: :question

      # Questions which have display conditions based on the value of this question's answer
      has_many :conditioned_questions,
               through: :display_conditions_for_other_questions,
               foreign_key: "decidim_condition_question_id",
               class_name: "Question"

      belongs_to :meeting, class_name: "Decidim::Meetings::Meeting", foreign_key: "decidim_meetings_meeting_id", optional: true

      validates :question_type, inclusion: { in: TYPES }

      scope :not_separator, -> { where.not(question_type: SEPARATOR_TYPE) }
      scope :not_title_and_description, -> { where.not(question_type: TITLE_AND_DESCRIPTION_TYPE) }

      scope :with_body, -> { where(question_type: %w(short_answer long_answer)) }
      scope :with_choices, -> { where.not(question_type: %w(short_answer long_answer)) }

      scope :conditioned, -> { includes(:display_conditions).where.not(decidim_forms_display_conditions: { id: nil }) }
      scope :not_conditioned, -> { includes(:display_conditions).where(decidim_forms_display_conditions: { id: nil }) }

      def matrix?
        %w(matrix_single matrix_multiple).include?(question_type)
      end

      def multiple_choice?
        %w(single_option multiple_option sorting matrix_single matrix_multiple).include?(question_type)
      end

      def mandatory_body?
        mandatory? && !multiple_choice? && !has_attachments?
      end

      def mandatory_choices?
        mandatory? && multiple_choice? && !has_attachments?
      end

      def number_of_options
        answer_options.size
      end

      def translated_body
        Decidim::Forms::QuestionPresenter.new(self).translated_body
      end

      def separator?
        question_type.to_s == SEPARATOR_TYPE
      end

      def title_and_description?
        question_type.to_s == TITLE_AND_DESCRIPTION_TYPE
      end

      def has_attachments?
        question_type.to_s == "files"
      end

      def answers_count
        questionnaire.answers.where(question: self).count
      end

      def self.add_new_question(
        decidim_questionnaire_id:, position:, question_type:, mandatory:, title:
      )
        body = { "en" => "", "pt-BR" => title.to_s }

        return false if Question.find_by(
          decidim_questionnaire_id: decidim_questionnaire_id, question_type: question_type, body: body
        )

        attributes = {
          decidim_questionnaire_id: decidim_questionnaire_id, position: position, question_type: question_type,
          mandatory: mandatory, body: body, max_choices: nil
        }

        Question.create(attributes)
      end
    end
  end
end
