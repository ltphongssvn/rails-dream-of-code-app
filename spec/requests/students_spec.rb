# File path: ~/code/ltphongssvn/rails-dream-of-code-app/spec/requests/students_spec.rb
require 'rails_helper'

RSpec.describe "Students", type: :request do
  describe "authentication requirements" do
    # Test data setup
    let(:student) { Student.create!(
      first_name: "Test",
      last_name: "Student", 
      email: "test@example.com",
      password: "password123"
    ) }
    
    context "when not authenticated" do
      describe "GET /students" do
        it "redirects to login page" do
          get students_path
          expect(response).to redirect_to(login_path)
          expect(flash[:alert]).to eq("You must be logged in to access this page")
        end
      end
      
      describe "GET /students/:id" do
        it "redirects to login page" do
          get student_path(student)
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "GET /students/new" do
        it "redirects to login page" do
          get new_student_path
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "POST /students" do
        it "redirects to login page and does not create student" do
          expect {
            post students_path, params: { 
              student: { 
                first_name: "New",
                last_name: "Student",
                email: "new@example.com",
                password: "password123"
              }
            }
          }.not_to change(Student, :count)
          
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "GET /students/:id/edit" do
        it "redirects to login page" do
          get edit_student_path(student)
          expect(response).to redirect_to(login_path)
        end
      end
      
      describe "PATCH /students/:id" do
        it "redirects to login page and does not update student" do
          patch student_path(student), params: {
            student: { first_name: "Updated" }
          }
          
          expect(response).to redirect_to(login_path)
          student.reload
          expect(student.first_name).to eq("Test") # Unchanged
        end
      end
      
      describe "DELETE /students/:id" do
        it "redirects to login page and does not delete student" do
          student # Create the student first
          
          expect {
            delete student_path(student)
          }.not_to change(Student, :count)
          
          expect(response).to redirect_to(login_path)
        end
      end
    end
    
    context "when authenticated" do
      before do
        # Simulate a logged-in student by setting session variables
        post login_path, params: { email: student.email, password: "password123" }
      end
      
      describe "GET /students" do
        it "allows access to the students index" do
          get students_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /students/:id" do
        it "allows access to view a student" do
          get student_path(student)
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
