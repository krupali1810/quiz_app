class Admin::QuestionsController < ApplicationController
  before_action :require_admin
  before_action :set_quiz
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = @quiz.questions.includes(:options).order(:created_at)
  end

  def new
    @question = @quiz.questions.build
    2.times { @question.options.build } # Build 2 options by default
  end

  def create
    @question = @quiz.questions.build(question_params)
    
    # Add debug logging
    Rails.logger.info "Question params: #{question_params.inspect}"
    Rails.logger.info "Question valid? #{@question.valid?}"
    Rails.logger.info "Question errors: #{@question.errors.full_messages}" unless @question.valid?

    if @question.save
      redirect_to admin_quiz_questions_path(@quiz), notice: "Question was successfully created."
    else
      # Ensure we have at least 2 options for the form
      while @question.options.size < 2
        @question.options.build
      end
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Ensure we have at least 2 options for editing
    while @question.options.size < 2
      @question.options.build
    end
  end

  def update
    if @question.update(question_params)
      redirect_to admin_quiz_questions_path(@quiz), notice: "Question was successfully updated."
    else
      # Ensure we have at least 2 options for the form
      while @question.options.reject(&:marked_for_destruction?).size < 2
        @question.options.build
      end
      flash.now[:alert] = "Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_quiz_questions_path(@quiz), notice: "Question was successfully deleted."
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = @quiz.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_text, :question_type, 
                                   options_attributes: [:id, :option_text, :is_correct, :_destroy])
  end

  def require_admin
    unless admin_logged_in?
      redirect_to admin_login_path, alert: "Please log in to access admin area"
    end
  end
end