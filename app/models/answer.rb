class Answer < ApplicationRecord
  #associations
  belongs_to :quiz_attempt
  belongs_to :question
  belongs_to :selected_option, class_name: 'Option', optional: true
  #validations
  validates :quiz_attempt_id, uniqueness: { scope: :question_id }

  scope :correct, -> { where(is_correct: true) }
  scope :incorrect, -> { where(is_correct: false) }
end