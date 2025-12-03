class Admin::QuizzesController < ApplicationController
  before_action :require_admin
  before_action :set_quiz, only: [:show, :edit, :update, :destroy, :toggle_published]

  def index
    redirect_to admin_path
  end

  def show
    # Quiz details view
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.created_by_id = current_admin_user.id

    if @quiz.save
      redirect_to admin_path, notice: "Quiz was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to admin_path, notice: "Quiz was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to admin_path, notice: "Quiz was successfully deleted."
  end

  def toggle_published
    @quiz.update(published: !@quiz.published)
    status = @quiz.published? ? "published" : "unpublished"
    redirect_to admin_path, notice: "Quiz was successfully #{status}."
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:title, :description, :published)
  end

  def require_admin
    unless admin_logged_in?
      redirect_to admin_login_path, alert: "Please log in to access admin area"
    end
  end
end