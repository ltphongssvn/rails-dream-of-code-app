# File path: ~/code/ltphongssvn/rails-dream-of-code-app/spec/requests/enrollments_spec.rb
require 'rails_helper'

RSpec.describe "Enrollments", type: :request do
  describe "authentication requirements" do
    # Set up the complete object graph needed for enrollments
    # First, create the base objects that courses depend on
    let(:coding_class) { CodingClass.create!(
      title: "Ruby Fundamentals",
      description: "Introduction to Ruby programming"
    ) }
    
    let(:trimester) { Trimester.create!(
      year: "2025",
      term: "Fall", 
      application_deadline: Date.today + 30.days,
      start_date: Date.today + 60.days,
      end_date: Date.today + 150.days
    ) }
    
    # Create a course that uses the coding class and trimester
    let(:course) { Course.create!(
      coding_class: coding_class,
      trimester: trimester,
      max_enrollment: 25
    ) }
    
    # Create a student who can enroll
    let(:student) { Student.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "password123"
    ) }
    
    # Finally, create an enrollment that connects student to course
    let(:enrollment) { Enrollment.create!(
      student: student,
      course: course,
      final_grade: nil  # Grade not yet assigned
    ) }
    
    # Create another student for authentication testing
    let(:authenticated_student) { Student.create!(
      first_name: "Jane",
      last_name: "Smith",
      email: "jane.smith@example.com",
      password: "securepass456"
    ) }
    
    context "when not authenticated" do
      describe "GET /enrollments" do
        it "redirects to login page" do
          get enrollments_path
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "GET /enrollments/:id" do
        it "redirects to login page" do
          get enrollment_path(enrollment)
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "GET /enrollments/new" do
        it "redirects to login page" do
          get new_enrollment_path
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "POST /enrollments" do
        it "redirects to login page and does not create enrollment" do
          # Create another course for the enrollment attempt
          another_course = Course.create!(
            coding_class: coding_class,
            trimester: trimester,
            max_enrollment: 20
          )
          
          expect {
            post enrollments_path, params: {
              enrollment: {
                student_id: student.id,
                course_id: another_course.id,
                final_grade: nil
              }
            }
          }.not_to change(Enrollment, :count)
          
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "GET /enrollments/:id/edit" do
        it "redirects to login page" do
          get edit_enrollment_path(enrollment)
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "PATCH /enrollments/:id" do
        it "redirects to login page and does not update enrollment" do
          patch enrollment_path(enrollment), params: {
            enrollment: { final_grade: "A" }
          }
          
          expect(response).to redirect_to(login_path)
          enrollment.reload
          expect(enrollment.final_grade).to be_nil  # Grade remains unchanged
        end
      end
      
      describe "DELETE /enrollments/:id" do
        it "redirects to login page and does not delete enrollment" do
          enrollment # Ensure the enrollment exists first
          
          expect {
            delete enrollment_path(enrollment)
          }.not_to change(Enrollment, :count)
          
          expect(response).to redirect_to(login_path)
        end
      end
    end
    
    context "when authenticated" do
      before do
        # Authenticate as the second student before each test
        post login_path, params: { 
          email: authenticated_student.email, 
          password: "securepass456" 
        }
      end
      
      describe "GET /enrollments" do
        it "allows access to enrollments index" do
          get enrollments_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /enrollments/:id" do
        it "allows access to view enrollment details" do
          get enrollment_path(enrollment)
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /enrollments/new" do
        it "allows access to new enrollment form" do
          get new_enrollment_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /enrollments/:id/edit" do
        it "allows access to edit enrollment form" do
          get edit_enrollment_path(enrollment)
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
