require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe '#is_past_application_deadline' do
    let(:trimester) {
      Trimester.create!(
        term: 'Fall',
        year: '2025',
        start_date: Date.new(2025, 9, 1),
        end_date: Date.new(2025, 12, 15),
        application_deadline: Date.new(2025, 8, 15)
      )
    }

    let(:coding_class) {
      CodingClass.create!(
        title: 'Ruby on Rails',
        description: 'Learn web development with Rails'
      )
    }

    let(:course) {
      Course.create!(
        coding_class: coding_class,
        trimester: trimester
      )
    }

    let(:student) {
      Student.create!(
        first_name: 'Test',
        last_name: 'Student',
        email: 'test@example.com'
      )
    }

    context 'when enrollment is created before the application deadline' do
      it 'returns false' do
        # Create enrollment with created_at before the deadline
        enrollment = Enrollment.create!(
          student: student,
          course: course,
          created_at: Date.new(2025, 8, 10) # 5 days before deadline
        )

        expect(enrollment.is_past_application_deadline).to be false
      end
    end

    context 'when enrollment is created on the application deadline' do
      it 'returns false' do
        # Create enrollment with created_at on the deadline
        enrollment = Enrollment.create!(
          student: student,
          course: course,
          created_at: Date.new(2025, 8, 15) # Exactly on deadline
        )

        expect(enrollment.is_past_application_deadline).to be false
      end
    end

    context 'when enrollment is created after the application deadline' do
      it 'returns true' do
        # Create enrollment with created_at after the deadline
        enrollment = Enrollment.create!(
          student: student,
          course: course,
          created_at: Date.new(2025, 8, 20) # 5 days after deadline
        )

        expect(enrollment.is_past_application_deadline).to be true
      end
    end
  end
end
