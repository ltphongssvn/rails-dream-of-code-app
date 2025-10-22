# File path: ~/code/ltphongssvn/rails-dream-of-code-app/app/controllers/courses_controller.rb
# File path: ~/code/ltphongssvn/code-the-dream-knifejaw-rails/practice/ThanhPhongLe/week-01/rails-dream-of-code-app/app/controllers/co
# # urses_controller.rb
# Courses Controller with eager loading optimization for show action
# Updated per code reviewer feedback to include proper eager loading

class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  # Allow public viewing of courses, but require authentication for modifications
  before_action :require_authentication, except: [:index, :show]

  # Authorization: Only admins can create, update, and delete courses
  before_action :require_admin, only: %i[ new create edit update destroy ]
  
  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end
  
  # GET /courses/1 or /courses/1.json
  def show
  end
  
  # GET /courses/new
  def new
    @course = Course.new
  end
  
  # GET /courses/1/edit
  def edit
  end
  
  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!
    
    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:coding_class_id, :trimester_id, :max_enrollment)
    end
end
  # Use callbacks to share common setup or constraints between actions.
  # Updated with eager loading to prevent N+1 queries when displaying course details
  def set_course
    @course = Course
                .includes(:coding_class, enrollments: :student)
                .find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:coding_class_id, :trimester_id, :max_enrollment)
  end
end
