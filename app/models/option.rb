class Option < ApplicationRecord
  #associations
  belongs_to :question
  has_many :answers, foreign_key: 'selected_option_id', dependent: :destroy
  #validations
  validates :option_text, presence: true

  scope :correct, -> { where(is_correct: true) }
  scope :incorrect, -> { where(is_correct: false) }

  def correct?
    is_correct
  end
end