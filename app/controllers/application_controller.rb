# File path: ~/code/ltphongssvn/rails-dream-of-code-app/app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  private
  
  # Simple session-based user identification for learning authorization concepts
  # In production, you would use a proper authentication system like Devise
  def current_user
    return nil unless session[:user_id] && session[:user_type]
    
    case session[:user_type]
    when 'Student'
      @current_user ||= Student.find_by(id: session[:user_id])
    when 'Mentor'
      @current_user ||= Mentor.find_by(id: session[:user_id])
    when 'Admin'
      # For now, admin is a special case - not tied to a model
      # We just return a simple object that responds to expected methods
      @current_user ||= OpenStruct.new(id: session[:user_id], role: 'Admin', email: 'admin@example.com')
    end
  end
  
  def logged_in?
    current_user.present?
  end
  
  def current_user_is_admin?
    session[:user_type] == 'Admin'
  end
  
  def current_user_is_student?
    session[:user_type] == 'Student' && current_user.is_a?(Student)
  end
  
  def current_user_is_mentor?
    session[:user_type] == 'Mentor' && current_user.is_a?(Mentor)
  end
  
  # Authorization helper methods for use in before_action filters
  def require_admin
    unless current_user_is_admin?
      flash[:alert] = "You must be an admin to access this page"
      redirect_to root_path
    end
  end
  
  def require_student
    unless current_user_is_student?
      flash[:alert] = "You must be a student to access this page"
      redirect_to root_path
    end
  end
  
  def require_mentor
    unless current_user_is_mentor?
      flash[:alert] = "You must be a mentor to access this page"
      redirect_to root_path
    end
  end
end
