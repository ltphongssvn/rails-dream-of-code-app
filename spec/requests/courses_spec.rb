# /spec/requests/courses_spec.rb
require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe 'GET /courses/:id' do
    before do
      @coding_class = CodingClass.create!(title: "Web Development")
      @trimester = Trimester.create!(
        year: "2025",
        term: "Spring",
        start_date: 1.month.from_now,
        application_deadline: 2.weeks.from_now,
        end_date: 4.months.from_now
      )
      @course = Course.create!(
        coding_class: @coding_class,
        trimester: @trimester,
        max_enrollment: 20
      )
      @student = Student.create!(
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com"
      )
      Enrollment.create!(course: @course, student: @student)
    end

    it "displays the course name and enrolled student names" do
      get "/courses/#{@course.id}"
      expect(response).to be_successful
      expect(response.body).to include("Web Development")
      expect(response.body).to include("John Doe")
    end
  end
end
