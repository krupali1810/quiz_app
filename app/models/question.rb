class Question < ApplicationRecord
  #associations
  belongs_to :quiz, class_name: 'Quiz', foreign_key: 'quizes_id'
  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy
  
  # Nested attributes
  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: proc { |attributes| attributes['option_text'].blank? }
  
  #validations
  validates :question_text, presence: true
  validates :question_type, presence: true, inclusion: { in: %w[multiple_choice true_false short_answer] }
  
  # Custom validations for multiple choice questions
  validate :must_have_correct_option, if: -> { question_type == 'multiple_choice' }
  validate :must_have_minimum_options, if: -> { question_type == 'multiple_choice' }
  
  private
  
  def must_have_correct_option
    return unless options.any?
    
    valid_options = options.reject(&:marked_for_destruction?)
    correct_options = valid_options.select(&:is_correct)
    
    if correct_options.empty?
      errors.add(:base, "Must have at least one correct option for multiple choice questions")
    end
  end
  
  def must_have_minimum_options
    return unless options.any?
    
    valid_options = options.reject(&:marked_for_destruction?).reject { |opt| opt.option_text.blank? }
    
    if valid_options.size < 2
      errors.add(:base, "Multiple choice questions must have at least 2 options")
    end
  end
end