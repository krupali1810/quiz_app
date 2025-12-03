class AdminController < ApplicationController
  before_action :require_admin, except: [:login, :create_session]

  def login
    redirect_to admin_path if session[:admin_logged_in]
  end

  def create_session
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      session[:admin_logged_in] = true
      session[:admin_user_id] = user.id
      redirect_to admin_path, notice: "Successfully logged in as #{user.name}"
    else
      flash.now[:alert] = "Invalid email or password"
      render :login
    end
  end

  def destroy_session
    session[:admin_logged_in] = nil
    session[:admin_user_id] = nil
    redirect_to root_path, notice: "Successfully logged out"
  end

  def dashboard
    @total_quizzes = Quiz.count
    @published_quizzes = Quiz.published.count
    @draft_quizzes = Quiz.draft.count
    @total_attempts = QuizAttempt.count
    @completed_attempts = QuizAttempt.completed.count
    @recent_attempts = QuizAttempt.includes(:quiz).order(created_at: :desc).limit(5)
    
    # Filter and search quizzes
    @quizzes = Quiz.includes(:creator, :questions).order(created_at: :desc)
    
    if params[:search].present?
      @quizzes = @quizzes.where("title ILIKE ? OR description ILIKE ?", 
                                "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    case params[:status]
    when 'published'
      @quizzes = @quizzes.published
    when 'draft'
      @quizzes = @quizzes.draft
    end
  end

  private

  def require_admin
    unless admin_logged_in?
      redirect_to admin_login_path, alert: "Please log in to access admin area"
    end
  end
end