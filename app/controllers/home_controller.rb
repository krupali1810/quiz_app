class HomeController < ApplicationController
  def index
    @quizzes = Quiz.published.includes(:creator, :questions)
  end
end