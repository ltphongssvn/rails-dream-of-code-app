# app/controllers/api/v1/enrollments_controller.rb
# API controller for managing course enrollments
# Handles: GET /api/v1/courses/:course_id/enrollments

module Api
  module V1
    class EnrollmentsController < ApplicationController
      # GET /api/v1/courses/:course_id/enrollments
      # Returns enrollments for a specific course in the current trimester
      def index
        # Step 2: Respond with dynamic data
        
        # First, find the current trimester based on today's date
        # A trimester is current if today falls between its start and end dates
        current_trimester = Trimester.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
        
        # If no current trimester exists, return empty enrollments
        unless current_trimester
          render json: { enrollments: [] }
          return
        end
        
        # Find the requested course and verify it belongs to the current trimester
        course = Course.find_by(id: params[:course_id], trimester_id: current_trimester.id)
        
        # If the course doesn't exist or isn't in the current trimester, return empty enrollments
        unless course
          render json: { enrollments: [] }
          return
        end
        
        # Get all enrollments for this course and build the response data
        # We're creating a hash for each enrollment with the student's information
        enrollments_data = course.enrollments.includes(:student).map do |enrollment|
          {
            id: enrollment.student.id,
            first_name: enrollment.student.first_name,
            last_name: enrollment.student.last_name,
            full_name: enrollment.student.full_name,
            email: enrollment.student.email
          }
        end
        
        # Return the enrollments in the expected format
        render json: { enrollments: enrollments_data }
      end
    end
  end
end
