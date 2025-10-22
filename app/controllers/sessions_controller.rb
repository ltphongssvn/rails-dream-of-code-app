# File path: ~/code/ltphongssvn/rails-dream-of-code-app/app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  # GET /login
  def new
    # Renders the login form
  end
  
  # POST /login
  def create
    # Try to find the user in either students or mentors table
    user = Student.find_by(email: params[:email]) || Mentor.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      # Store user info in session
      session[:user_id] = user.id
      session[:user_type] = user.class.name
      
      # Redirect based on user type
      if user.is_a?(Student)
        redirect_to root_path, notice: "Welcome back, #{user.full_name}!"
      else
        redirect_to root_path, notice: "Welcome back!"
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end
  
  # DELETE /logout
  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    redirect_to root_path, notice: "You have been logged out"
  end
end
