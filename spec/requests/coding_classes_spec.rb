# File path: ~/code/ltphongssvn/rails-dream-of-code-app/spec/requests/coding_classes_spec.rb
require 'rails_helper'

RSpec.describe "CodingClasses", type: :request do
  describe "authentication requirements" do
    # Create test data for coding class
    let(:coding_class) { CodingClass.create!(
      title: "Advanced Ruby Patterns",
      description: "Deep dive into Ruby metaprogramming and design patterns"
    ) }
    
    # Create a test student for potential future authentication
    let(:student) { Student.create!(
      first_name: "Test",
      last_name: "Student",
      email: "test@example.com",
      password: "password123"
    ) }
    
    # NOTE: Currently, the CodingClassesController has NO authentication requirements.
    # This test documents the current behavior, but this is likely a security issue.
    # Consider adding authentication requirements, especially for create/update/destroy actions.
    
    context "when not authenticated (current behavior - NO protection)" do
      describe "GET /coding_classes" do
        it "allows public access (currently unprotected)" do
          get coding_classes_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /coding_classes/:id" do
        it "allows public access (currently unprotected)" do
          get coding_class_path(coding_class)
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /coding_classes/new" do
        it "allows public access (SECURITY CONCERN - should require authentication)" do
          get new_coding_class_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "POST /coding_classes" do
        it "allows creation without authentication (SECURITY CONCERN)" do
          expect {
            post coding_classes_path, params: {
              coding_class: {
                title: "New Unauthorized Class",
                description: "This should not be allowed without authentication"
              }
            }
          }.to change(CodingClass, :count).by(1)
          
          # Currently redirects to the created class, but should redirect to login
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(CodingClass.last)
        end
      end
      
      describe "GET /coding_classes/:id/edit" do
        it "allows public access (SECURITY CONCERN - should require authentication)" do
          get edit_coding_class_path(coding_class)
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "PATCH /coding_classes/:id" do
        it "allows updates without authentication (SECURITY CONCERN)" do
          patch coding_class_path(coding_class), params: {
            coding_class: { title: "Hacked Title" }
          }
          
          expect(response).to have_http_status(:redirect)
          coding_class.reload
          expect(coding_class.title).to eq("Hacked Title") # This shouldn't be possible!
        end
      end
      
      describe "DELETE /coding_classes/:id" do
        it "allows deletion without authentication (CRITICAL SECURITY CONCERN)" do
          coding_class # Create it first
          
          expect {
            delete coding_class_path(coding_class)
          }.to change(CodingClass, :count).by(-1)
          
          expect(response).to have_http_status(:redirect)
        end
      end
    end
    
    # These tests would pass if authentication were added to the controller
    context "when authenticated (future recommended behavior)" do
      before do
        post login_path, params: { email: student.email, password: "password123" }
      end
      
      describe "GET /coding_classes" do
        it "allows viewing class catalog" do
          get coding_classes_path
          expect(response).to have_http_status(:success)
        end
      end
      
      describe "GET /coding_classes/:id" do
        it "allows viewing class details" do
          get coding_class_path(coding_class)
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
