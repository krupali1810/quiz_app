class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  
  # Helper methods available in all controllers and views
  helper_method :current_admin_user, :admin_logged_in?

  private

  def current_admin_user
    @current_admin_user ||= User.find_by(id: session[:admin_user_id]) if session[:admin_user_id]
  end

  def admin_logged_in?
    session[:admin_logged_in] == true
  end
end
