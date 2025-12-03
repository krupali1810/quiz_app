class Quiz < ApplicationRecord
  #associations
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  has_many :questions, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy
  #validations
  validates :title, presence: true
  validates :created_by, presence: true

  scope :published, -> { where(is_published: true) }
  scope :draft, -> { where(is_published: false) }
end