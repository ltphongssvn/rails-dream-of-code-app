# File: spec/requests/students_spec.rb
require 'rails_helper'

RSpec.describe "Students", type: :request do
  describe "GET /students/:id/dashboard" do
    let!(:student) { Student.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com"
    ) }

    let!(:coding_class) { CodingClass.create!(title: "Web Development") }
    let!(:trimester) { Trimester.create!(
      term: "Fall",
      year: 2023,
      start_date: 1.month.ago,
      end_date: 2.months.from_now,
      application_deadline: 2.months.ago
    ) }
    let!(:course) { Course.create!(coding_class: coding_class, trimester: trimester, max_enrollment: 20) }
    let!(:enrollment) { Enrollment.create!(student: student, course: course, final_grade: "completed") }

    it "returns a successful response" do
      get "/students/#{student.id}/dashboard"
      expect(response).to have_http_status(200)
    end

    it "displays the student's name in the title" do
      get "/students/#{student.id}/dashboard"
      expect(response.body).to include("#{student.full_name} Dashboard")
    end

    it "displays the student's email" do
      get "/students/#{student.id}/dashboard"
      expect(response.body).to include(student.email)
    end

    it "displays course enrollment information" do
      get "/students/#{student.id}/dashboard"
      expect(response.body).to include("Course Enrollments")
      expect(response.body).to include(course.title)
      expect(response.body).to include("#{trimester.term} #{trimester.year}")
      expect(response.body).to include("Completed")
    end

    it "displays enrollment summary" do
      get "/students/#{student.id}/dashboard"
      expect(response.body).to include("Total Enrollments:</strong> 1")
      expect(response.body).to include("Completed Courses:</strong> 1")
    end

    context "when student has no enrollments" do
      let!(:student_no_enrollments) { Student.create!(
        first_name: "Jane",
        last_name: "Smith",
        email: "jane.smith@example.com"
      ) }

      it "displays no enrollments message" do
        get "/students/#{student_no_enrollments.id}/dashboard"
        expect(response.body).to include("No course enrollments found for this student")
      end
    end
  end
end