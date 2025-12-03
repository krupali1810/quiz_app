class Quiz < ApplicationRecord
  self.table_name = 'quizes'
  
  #associations
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id'
  has_many :questions, foreign_key: 'quizes_id', dependent: :destroy
  has_many :quiz_attempts, foreign_key: 'quizes_id', dependent: :destroy
  
  #validations
  validates :title, presence: true
  validates :created_by_id, presence: true

  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  
  def is_published?
    published
  end
end