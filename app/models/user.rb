class User < ApplicationRecord
  has_secure_password
  
  #associations
  has_many :quizzes, class_name: 'Quiz', foreign_key: 'created_by_id', dependent: :destroy
  
  #validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2 }
end