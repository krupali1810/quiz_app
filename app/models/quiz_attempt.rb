class QuizAttempt < ApplicationRecord
  #associations
  belongs_to :quiz
  has_many :answers, dependent: :destroy

  #validations
  validates :participant_name, presence: true, length: { minimum: 2 }
  validates :participant_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :score, numericality: { greater_than_or_equal_to: 0 }
  validates :total_questions, numericality: { greater_than_or_equal_to: 0 }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where(completed_at: nil) }
end