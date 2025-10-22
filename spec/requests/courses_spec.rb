# File path: ~/code/ltphongssvn/rails-dream-of-code-app/spec/requests/courses_spec.rb
require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe "authentication requirements" do
    # First create the associated records that Course depends on
    let(:coding_class) { CodingClass.create!(
      title: "Test Class",
      description: "A test coding class for our specs"
    ) }
    
    let(:trimester) { Trimester.create!(
      year: "2025",
      term: "Fall",
      application_deadline: Date.today + 30.days,
      start_date: Date.today + 60.days,
      end_date: Date.today + 150.days
    ) }
    
    # Now create the course with valid associations
    let(:course) { Course.create!(
      coding_class: coding_class,  # Using the actual object instead of just an ID
      trimester: trimester,        # This ensures the associations exist
      max_enrollment: 30
    ) }
    
    # Create a test student for authenticated scenarios
    let(:student) { Student.create!(
      first_name: "Test",
      last_name: "Student",
      email: "test@example.com",
      password: "password123"
    ) }
    
    context "when not authenticated" do
      describe "GET /courses (index)" do
        it "allows public access to view course list" do
          get courses_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /courses/:id (show)" do
        it "allows public access to view course details" do
          get course_path(course)
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /courses/new" do
        it "redirects to login page" do
          get new_course_path
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "POST /courses" do
        it "redirects to login page and does not create course" do
          # Need to create these for the params to be valid
          another_coding_class = CodingClass.create!(
            title: "Another Class",
            description: "Another test class"
          )
          another_trimester = Trimester.create!(
            year: "2026",
            term: "Spring",
            application_deadline: Date.today + 90.days,
            start_date: Date.today + 120.days,
            end_date: Date.today + 210.days
          )
          
          expect {
            post courses_path, params: {
              course: {
                coding_class_id: another_coding_class.id,
                trimester_id: another_trimester.id,
                max_enrollment: 25
              }
            }
          }.not_to change(Course, :count)
          
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "GET /courses/:id/edit" do
        it "redirects to login page" do
          get edit_course_path(course)
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "PATCH /courses/:id" do
        it "redirects to login page and does not update course" do
          original_enrollment = course.max_enrollment
          
          patch course_path(course), params: {
            course: { max_enrollment: 50 }
          }
          
          expect(response).to redirect_to(login_path)
          course.reload
          expect(course.max_enrollment).to eq(original_enrollment)
        end
      end
      
      describe "DELETE /courses/:id" do
        it "redirects to login page and does not delete course" do
          course # Ensure course exists before attempting deletion
          
          expect {
            delete course_path(course)
          }.not_to change(Course, :count)
          
          expect(response).to redirect_to(login_path)
        end
      end
    end
    
    context "when authenticated" do
      before do
        # Log in the test student before each authenticated test
        post login_path, params: { email: student.email, password: "password123" }
      end
      
      describe "GET /courses (index)" do
        it "allows access to view course list" do
          get courses_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /courses/:id (show)" do
        it "allows access to view course details" do
          get course_path(course)
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /courses/new" do
        it "allows access to new course form" do
          get new_course_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /courses/:id/edit" do
        it "allows access to edit course form" do
          get edit_course_path(course)
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
