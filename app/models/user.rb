class User < ApplicationRecord
  #associations
  has_many :quizzes, foreign_key: 'created_by', dependent: :destroy
  #validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2 }
  validates :password_digest, presence: true
end