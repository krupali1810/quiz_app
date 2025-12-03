class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :start, :submit, :result]
  
  def show
    redirect_to start_quiz_path(@quiz)
  end
  
  def start
    @quiz_attempt = QuizAttempt.new
  end
  
  def submit
    if params[:step] == 'user_info'
      # Step 1: Collect user information
      @quiz_attempt = @quiz.quiz_attempts.build(user_info_params)
      @quiz_attempt.total_questions = @quiz.questions.count
      
      if @quiz_attempt.save
        session[:quiz_attempt_id] = @quiz_attempt.id
        @questions = @quiz.questions.includes(:options).order(:created_at)
        render :questions
      else
        flash.now[:alert] = "Please fix the errors below."
        render :start, status: :unprocessable_entity
      end
    elsif params[:step] == 'answers'
      # Step 2: Process answers
      @quiz_attempt = QuizAttempt.find(session[:quiz_attempt_id])
      
      if @quiz_attempt && process_answers(params[:answers])
        @quiz_attempt.update(completed_at: Time.current)
        session[:quiz_attempt_id] = nil
        redirect_to result_quiz_path(@quiz, attempt_id: @quiz_attempt.id)
      else
        @questions = @quiz.questions.includes(:options).order(:created_at)
        flash.now[:alert] = "Please answer all questions"
        render :questions
      end
    end
  end
  
  def result
    @quiz_attempt = @quiz.quiz_attempts.find(params[:attempt_id])
    @answers = @quiz_attempt.answers.includes(:question, :selected_option)
  end
  
  private
  
  def set_quiz
    @quiz = Quiz.published.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Quiz not found or not available"
  end
  
  def user_info_params
    params.require(:quiz_attempt).permit(:participant_name, :participant_email)
  end
  
  def process_answers(answers_params)
    return false unless answers_params
    
    score = 0
    answers_params.each do |question_id, answer_value|
      next if answer_value.blank?
      
      question = @quiz.questions.find(question_id)
      
      if question.question_type == 'multiple_choice' || 
         (question.question_type == 'true_false' && question.options.any?)
        # Handle questions with actual option records
        selected_option = question.options.find(answer_value)
        is_correct = selected_option.is_correct
        score += 1 if is_correct
        
        @quiz_attempt.answers.create!(
          question: question,
          selected_option: selected_option,
          is_correct: is_correct
        )
      else
        # Handle true/false without options or short answer
        is_correct = false # Default to false
        
        if question.question_type == 'true_false'
          # For true/false without option records, assume correct answer is stored somewhere
          # or make it always incorrect for now (this needs proper setup)
          is_correct = false # Manual review needed
        end
        
        @quiz_attempt.answers.create!(
          question: question,
          selected_option: nil,
          is_correct: is_correct
        )
      end
    end
    
    @quiz_attempt.update(score: score)
    true
  rescue => e
    Rails.logger.error "Error processing answers: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    false
  end
end