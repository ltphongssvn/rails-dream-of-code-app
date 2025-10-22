# File path: ~/code/ltphongssvn/rails-dream-of-code-app/spec/requests/mentors_spec.rb
require 'rails_helper'

RSpec.describe "Mentors", type: :request do
  describe "authentication requirements" do
    # Create test data for mentor with required password field
    let(:mentor) { Mentor.create!(
      first_name: "Jane",
      last_name: "Professor",
      email: "jane.professor@codeschool.edu",
      password: "secure_mentor_pass",  # Mentors need passwords like students
      max_concurrent_students: 10
    ) }
    
    # Create a test student for authentication scenarios
    let(:student) { Student.create!(
      first_name: "Test",
      last_name: "Student",
      email: "test.student@example.com",
      password: "password123"
    ) }
    
    # WARNING: The MentorsController currently has NO authentication checks.
    # While the Mentor model requires passwords (suggesting mentors can log in),
    # the controller doesn't verify if users are authenticated before allowing actions.
    # This creates a security gap where mentor data can be manipulated without login.
    
    context "when not authenticated (current VULNERABLE behavior)" do
      describe "GET /mentors" do
        it "allows public access to mentor list (SECURITY CONCERN)" do
          get mentors_path
          expect(response).to have_http_status(:success)
          # Exposes list of all mentors without authentication
        end
      end
      
      describe "GET /mentors/:id" do
        it "allows public access to mentor details (SECURITY CONCERN)" do
          get mentor_path(mentor)
          expect(response).to have_http_status(:success)
          # Exposes mentor email and details without authentication
        end
      end
      
      describe "GET /mentors/new" do
        it "allows public access to create mentor form (CRITICAL SECURITY ISSUE)" do
          get new_mentor_path
          expect(response).to have_http_status(:success)
          # Form is accessible but at least password is required by model
        end
      end
      
      describe "POST /mentors" do
        it "allows creating mentors without authentication if password provided (CRITICAL ISSUE)" do
          expect {
            post mentors_path, params: {
              mentor: {
                first_name: "Fake",
                last_name: "Mentor",
                email: "fake.mentor@example.com",
                password: "hacker123",  # With password, creation succeeds!
                max_concurrent_students: 100
              }
            }
          }.to change(Mentor, :count).by(1)
          
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(Mentor.last)
          
          # Anyone knowing the parameter structure can create mentor accounts
        end
        
        it "at least prevents mentor creation without password due to model validation" do
          expect {
            post mentors_path, params: {
              mentor: {
                first_name: "Invalid",
                last_name: "Mentor",
                email: "no.password@example.com",
                max_concurrent_students: 50
              }
            }
          }.not_to change(Mentor, :count)
          
          # Model validation provides minimal protection
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
      
      describe "GET /mentors/:id/edit" do
        it "allows public access to edit form (CRITICAL SECURITY ISSUE)" do
          get edit_mentor_path(mentor)
          expect(response).to have_http_status(:success)
          # Edit forms should never be publicly accessible
        end
      end
      
      describe "PATCH /mentors/:id" do
        it "allows modifying mentor details without authentication (CRITICAL ISSUE)" do
          original_email = mentor.email
          
          patch mentor_path(mentor), params: {
            mentor: { 
              email: "hijacked@attacker.com",
              max_concurrent_students: 0  # Prevents mentor from taking students!
            }
          }
          
          expect(response).to have_http_status(:redirect)
          mentor.reload
          expect(mentor.email).to eq("hijacked@attacker.com")
          expect(mentor.max_concurrent_students).to eq(0)
          
          # Mentor accounts can be hijacked by anyone knowing the URL
        end
        
        it "allows changing mentor passwords without authentication (EXTREME SECURITY RISK)" do
          patch mentor_path(mentor), params: {
            mentor: { 
              password: "attacker_controlled_password"
            }
          }
          
          expect(response).to have_http_status(:redirect)
          mentor.reload
          # Attacker can now log in as this mentor!
          expect(mentor.authenticate("attacker_controlled_password")).to be_truthy
        end
      end
      
      describe "DELETE /mentors/:id" do
        it "allows deleting mentors without authentication (CRITICAL SECURITY ISSUE)" do
          mentor # Create the mentor first
          
          expect {
            delete mentor_path(mentor)
          }.to change(Mentor, :count).by(-1)
          
          expect(response).to have_http_status(:redirect)
          
          # Deleting mentors disrupts student guidance and academic integrity
        end
      end
    end
    
    # These tests demonstrate what SHOULD happen with proper authentication
    context "when authenticated as student (shows even students can access mentor data)" do
      before do
        # Authenticating as a student, not a mentor
        post login_path, params: { email: student.email, password: "password123" }
      end
      
      describe "GET /mentors" do
        it "currently allows students to view mentor list" do
          get mentors_path
          expect(response).to have_http_status(:success)
          # Note: You might want different access levels for students vs mentors
        end
      end
      
      describe "GET /mentors/:id" do
        it "currently allows students to view mentor details" do
          get mentor_path(mentor)
          expect(response).to have_http_status(:success)
        end
      end
      
      # Important note: In a properly secured system, students probably shouldn't
      # be able to create, edit, or delete mentors - that should require admin access
    end
  end
end
