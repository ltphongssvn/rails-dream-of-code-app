# File path: ~/code/ltphongssvn/rails-dream-of-code-app/app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Make these methods available in views
  helper_method :current_user, :logged_in?
  
  private
  
  # Returns the currently logged-in user (Student or Mentor), or nil if no one is logged in
  def current_user
    return @current_user if defined?(@current_user)
    
    if session[:user_id] && session[:user_type]
      @current_user = case session[:user_type]
                      when "Student"
                        Student.find_by(id: session[:user_id])
                      when "Mentor"
                        Mentor.find_by(id: session[:user_id])
                      end
    else
      @current_user = nil
    end
  end
  
  # Returns true if a user is logged in, false otherwise
  def logged_in?
    current_user.present?
  end
  
  # Requires a user to be logged in to access the action
  def require_authentication
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page"
      redirect_to login_path
    end
  end
  
  # Requires the current user to be a student
  def require_student
    unless logged_in? && current_user.is_a?(Student)
      flash[:alert] = "You must be logged in as a student to access this page"
      redirect_to root_path
    end
  end
  
  # Requires the current user to be a mentor
  def require_mentor
    unless logged_in? && current_user.is_a?(Mentor)
      flash[:alert] = "You must be logged in as a mentor to access this page"
      redirect_to root_path
    end
  end
end
