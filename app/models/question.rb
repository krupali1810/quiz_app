class Question < ApplicationRecord
  #associations
  belongs_to :quiz
  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy
  #validations
  validates :question_text, presence: true
  validates :question_type, inclusion: { in: %w[multiple_choice true_false] }
end