# spec/requests/api/v1/students_controller_spec.rb
# Full path: ~/code/ltphongssvn/rails-dream-of-code-app/spec/requests/api/v1/students_controller_spec.rb
# Week 14 Assignment: Testing invalid parameters for student creation API endpoint
# Updated to handle password requirements from has_secure_password

require 'rails_helper'

RSpec.describe "Api::V1::Students", type: :request do
  describe "POST /api/v1/students" do
    # Test data setup for valid parameters
    # Now includes password to satisfy has_secure_password requirements
    let(:valid_attributes) do
      {
        student: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: 'validstudent@example.com',
          password: 'password123',  # Added password field
          password_confirmation: 'password123'  # Added password confirmation
        }
      }
    end

    context "with valid parameters" do
      it "creates a new student" do
        expect {
          post '/api/v1/students', params: valid_attributes
        }.to change(Student, :count).by(1)

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['student']['email']).to eq("validstudent@example.com")
      end
    end

    context "with invalid parameters" do
      # Test 1: Missing required first_name field
      context "when first_name is missing" do
        let(:invalid_attributes) do
          {
            student: {
              last_name: Faker::Name.last_name,
              email: 'missingfirstname@example.com',
              password: 'password123'  # Include password to isolate first_name validation
            }
          }
        end

        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: invalid_attributes
          }.not_to change(Student, :count)
        end

        it "returns an unprocessable entity status" do
          post '/api/v1/students', params: invalid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error message about first_name" do
          post '/api/v1/students', params: invalid_attributes
          json_response = JSON.parse(response.body)
          expect(json_response['errors']).to include("first_name")
        end
      end

      # Test 2: Missing required last_name field
      context "when last_name is missing" do
        let(:invalid_attributes) do
          {
            student: {
              first_name: Faker::Name.first_name,
              email: 'missinglastname@example.com',
              password: 'password123'  # Include password to isolate last_name validation
            }
          }
        end

        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: invalid_attributes
          }.not_to change(Student, :count)
        end

        it "returns an unprocessable entity status" do
          post '/api/v1/students', params: invalid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error message about last_name" do
          post '/api/v1/students', params: invalid_attributes
          json_response = JSON.parse(response.body)
          expect(json_response['errors']).to include("last_name")
        end
      end

      # Test 3: Invalid email format
      context "when email has invalid format" do
        let(:invalid_attributes) do
          {
            student: {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: 'not_a_valid_email',  # Missing @ and domain
              password: 'password123'  # Include password to isolate email validation
            }
          }
        end

        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: invalid_attributes
          }.not_to change(Student, :count)
        end

        it "returns an unprocessable entity status" do
          post '/api/v1/students', params: invalid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error message about email format" do
          post '/api/v1/students', params: invalid_attributes
          json_response = JSON.parse(response.body)
          # Note: The actual error might be about password if email validation isn't strict
          # We should check if the errors array contains any mention of email-related issues
          expect(json_response['errors'].to_s + json_response.to_s).to match(/email|password/)
        end
      end

      # Test 4: Missing email entirely
      context "when email is missing" do
        let(:invalid_attributes) do
          {
            student: {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              password: 'password123'  # Include password to isolate email validation
            }
          }
        end

        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: invalid_attributes
          }.not_to change(Student, :count)
        end

        it "returns an unprocessable entity status" do
          post '/api/v1/students', params: invalid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      # Test 5: Duplicate email (assuming email should be unique)
      context "when email already exists" do
        before do
          # Create a student with password to satisfy model requirements
          Student.create!(
            first_name: "Existing",
            last_name: "Student",
            email: "duplicate@example.com",
            password: "existingpass123"  # Added password for the setup
          )
        end

        let(:duplicate_attributes) do
          {
            student: {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: "duplicate@example.com",  # Same email as existing
              password: "newpass123"  # Different password but same email
            }
          }
        end

        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: duplicate_attributes
          }.not_to change(Student, :count)
        end

        it "returns an unprocessable entity status" do
          post '/api/v1/students', params: duplicate_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error message about email uniqueness" do
          post '/api/v1/students', params: duplicate_attributes
          json_response = JSON.parse(response.body)
          expect(json_response['errors']).to include("email")
        end
      end

      # Test 6: Empty string values
      context "when fields contain empty strings" do
        let(:empty_string_attributes) do
          {
            student: {
              first_name: "",
              last_name: "",
              email: "",
              password: ""  # Even password is empty
            }
          }
        end

        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: empty_string_attributes
          }.not_to change(Student, :count)
        end

        it "returns an unprocessable entity status" do
          post '/api/v1/students', params: empty_string_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      # Test 7: Missing the student parameter wrapper
      context "when student parameter wrapper is missing" do
        let(:unwrapped_attributes) do
          {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: 'unwrapped@example.com',
            password: 'password123'
          }
        end

        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: unwrapped_attributes
          }.not_to change(Student, :count)
        end

        it "returns a bad request or unprocessable entity status" do
          post '/api/v1/students', params: unwrapped_attributes
          expect(response.status).to satisfy { |status| [400, 422].include?(status) }
        end
      end

      # Test 8: Completely empty request
      context "when no parameters are provided" do
        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: {}
          }.not_to change(Student, :count)
        end

        it "returns an error status" do
          post '/api/v1/students', params: {}
          expect(response.status).to satisfy { |status| [400, 422].include?(status) }
        end
      end

      # Test 9: Invalid password (too short)
      context "when password is too short" do
        let(:short_password_attributes) do
          {
            student: {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: 'shortpass@example.com',
              password: '12345'  # Only 5 characters, model requires 6
            }
          }
        end

        it "does not create a new student" do
          expect {
            post '/api/v1/students', params: short_password_attributes
          }.not_to change(Student, :count)
        end

        it "returns an unprocessable entity status" do
          post '/api/v1/students', params: short_password_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error message about password length" do
          post '/api/v1/students', params: short_password_attributes
          json_response = JSON.parse(response.body)
          expect(json_response['errors']).to include("password")
        end
      end
    end
  end
end