class Admin::QuizAttemptsController < ApplicationController
  before_action :require_admin
  before_action :set_quiz_attempt, only: [:show, :destroy]

  def index
    @quiz_attempts = QuizAttempt.includes(:quiz)
                                .order(created_at: :desc)
    
    # Filter by quiz if specified
    if params[:quiz_id].present?
      @quiz_attempts = @quiz_attempts.where(quizes_id: params[:quiz_id])
      @quiz = Quiz.find(params[:quiz_id])
    end
    
    # Filter by completion status
    case params[:status]
    when 'completed'
      @quiz_attempts = @quiz_attempts.completed
    when 'in_progress'
      @quiz_attempts = @quiz_attempts.in_progress
    end
    
    # Search by participant name or email
    if params[:search].present?
      @quiz_attempts = @quiz_attempts.where(
        "participant_name ILIKE ? OR participant_email ILIKE ?", 
        "%#{params[:search]}%", "%#{params[:search]}%"
      )
    end

    # Stats for the filtered results
    @total_attempts = @quiz_attempts.count
    @completed_count = @quiz_attempts.completed.count
    @average_score = @quiz_attempts.completed.average(:score)&.round(1) || 0
  end

  def show
    @answers = @quiz_attempt.answers.includes(:question, :selected_option)
  end

  def destroy
    @quiz_attempt.destroy
    redirect_to admin_quiz_attempts_path, notice: "Quiz attempt was successfully deleted."
  end

  def bulk_destroy
    attempt_ids = params[:attempt_ids]
    if attempt_ids.present?
      begin
        # Verify all attempts exist and belong to valid quizzes
        attempts_to_delete = QuizAttempt.where(id: attempt_ids)
        
        if attempts_to_delete.count != attempt_ids.length
          redirect_to admin_quiz_attempts_path, alert: "Some quiz attempts could not be found."
          return
        end
        
        deleted_count = attempts_to_delete.destroy_all.count
        redirect_to admin_quiz_attempts_path, notice: "#{deleted_count} quiz attempt#{deleted_count == 1 ? '' : 's'} #{deleted_count == 1 ? 'was' : 'were'} successfully deleted."
      rescue => e
        Rails.logger.error "Bulk delete error: #{e.message}"
        redirect_to admin_quiz_attempts_path, alert: "An error occurred while deleting quiz attempts. Please try again."
      end
    else
      redirect_to admin_quiz_attempts_path, alert: "No attempts selected for deletion."
    end
  end

  private

  def set_quiz_attempt
    @quiz_attempt = QuizAttempt.find(params[:id])
  end

  def require_admin
    unless admin_logged_in?
      redirect_to admin_login_path, alert: "Please log in to access admin area"
    end
  end
end