# app/controllers/api/v1/students_controller.rb
# Full path: ~/code/ltphongssvn/rails-dream-of-code-app/app/controllers/api/v1/students_controller.rb
# Week 14: API controller for creating students with comprehensive error handling

module Api
  module V1
    class StudentsController < ApplicationController
      # Skip CSRF protection for API endpoints
      # APIs typically use token authentication instead of sessions
      skip_before_action :verify_authenticity_token

      # POST /api/v1/students
      # Creates a new student with the provided parameters
      def create
        # Build a new student instance with the permitted parameters
        # We're not saving yet, just creating the object in memory
        @student = Student.new(student_params)

        # Attempt to save the student to the database
        # The save method returns true if successful, false if validation fails
        if @student.save
          # Success path: Student was created successfully
          # Return the created student as JSON with a 201 Created status
          # The 201 status code specifically indicates a resource was created
          render json: {
            student: {
              id: @student.id,
              first_name: @student.first_name,
              last_name: @student.last_name,
              email: @student.email,
              full_name: @student.full_name
            }
          }, status: :created
        else
          # Failure path: Validation failed
          # Return the validation errors as JSON with a 422 Unprocessable Entity status
          # The 422 status indicates the request was understood but contains invalid data

          # Format the errors in a way that's useful for API consumers
          # We'll create a hash where each field name maps to its error messages
          formatted_errors = {}

          @student.errors.each do |error|
            # error.attribute gives us the field name (e.g., :first_name)
            # error.message gives us the validation message (e.g., "can't be blank")
            field_name = error.attribute.to_s
            formatted_errors[field_name] ||= []
            formatted_errors[field_name] << error.message
          end

          # Also include the field names as a simple array for the tests that expect it
          # This ensures compatibility with tests checking for specific field names
          error_fields = @student.errors.map { |e| e.attribute.to_s }.uniq

          render json: {
            errors: error_fields,
            error_details: formatted_errors,
            message: "Validation failed"
          }, status: :unprocessable_entity
        end
      rescue ActionController::ParameterMissing => e
        # Handle the case where the 'student' parameter wrapper is missing entirely
        # This happens when someone sends { first_name: "John" } instead of { student: { first_name: "John" } }
        render json: {
          errors: ["student parameter is required"],
          message: "Bad request: #{e.message}"
        }, status: :bad_request
      end

      private

      # Strong parameters: explicitly specify which parameters are allowed
      # This is a security feature that prevents mass assignment vulnerabilities
      def student_params
        # We require the 'student' key to be present in the params
        # and permit only specific fields within it
        # Note: We're including password and password_confirmation because
        # the Student model has has_secure_password
        params.require(:student).permit(
          :first_name,
          :last_name,
          :email,
          :password,
          :password_confirmation
        )
      end
    end
  end
end