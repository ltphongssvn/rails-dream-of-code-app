# File path: ~/code/ltphongssvn/rails-dream-of-code-app/app/controllers/submissions_controller.rb
# File: app/controllers/submissions_controller.rb
class SubmissionsController < ApplicationController
  # Authorization: Students can create submissions, Mentors can edit/update them
  before_action :require_student, only: %i[ new create ]
  before_action :require_mentor, only: %i[ edit update ]
  
  # GET /submissions/new
  def new
    @course = Course.find(params[:course_id])
    @submission = Submission.new
    
    # TODO: These need to be properly populated
    # Students should only see their own enrollment in the dropdown
    # Should only show lessons for this specific course
    @enrollments = Enrollment.where(course_id: @course.id, student_id: current_user.id) if current_user_is_student?
    @lessons = @course.lessons if @course.respond_to?(:lessons)
    @enrollments = @course.enrollments.includes(:student)
    @lessons = @course.lessons
  end
  
  def create
    @course = Course.find(params[:course_id])
    @submission = Submission.new(submission_params)
    
    if @submission.save
      redirect_to course_path(@course), notice: 'Submission was successfully created.'
    else
      # Re-populate the form data on validation failure
      @enrollments = Enrollment.where(course_id: @course.id, student_id: current_user.id) if current_user_is_student?
      @lessons = @course.lessons if @course.respond_to?(:lessons)
      @enrollments = @course.enrollments.includes(:student)
      @lessons = @course.lessons
      render :new
    end
  end
  
  # GET /submissions/1/edit
  def edit
    @submission = Submission.find(params[:id])
    @course = Course.find(@submission.lesson.course_id) if @submission.lesson
  end
  
  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
    @submission = Submission.find(params[:id])
    
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully reviewed.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Only allow a list of trusted parameters through.
    def submission_params
      # Students can set lesson and enrollment when creating
      # Mentors can set review fields when updating
      if current_user_is_student?
        params.require(:submission).permit(:lesson_id, :enrollment_id)
      elsif current_user_is_mentor?
        params.require(:submission).permit(:mentor_id, :review_result, :reviewed_at)
      else
        # Admins might have full access if needed
        params.require(:submission).permit(:lesson_id, :enrollment_id, :mentor_id, :review_result, :reviewed_at)
      end
    end
  # Only allow a list of trusted parameters through.
  def submission_params
    params.require(:submission).permit(:lesson_id, :enrollment_id, :mentor_id, :review_result, :reviewed_at)
  end
end
