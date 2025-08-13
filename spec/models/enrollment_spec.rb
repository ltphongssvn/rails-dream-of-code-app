# spec/models/enrollment_spec.rb
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

    # DRY refactoring: Single enrollment definition that uses enrollment_date
    # Each context below defines its own enrollment_date value
    let(:enrollment) {
      Enrollment.create!(
        student: student,
        course: course,
        created_at: enrollment_date
      )
    }

    context 'when enrollment is created before the application deadline' do
      # Define the date for this specific context
      let(:enrollment_date) { Date.new(2025, 8, 10) } # 5 days before deadline

      it 'returns false' do
        expect(enrollment.is_past_application_deadline).to be false
      end
    end

    context 'when enrollment is created on the application deadline' do
      # Define the date for this specific context
      let(:enrollment_date) { Date.new(2025, 8, 15) } # Exactly on deadline

      it 'returns false' do
        expect(enrollment.is_past_application_deadline).to be false
      end
    end

    context 'when enrollment is created after the application deadline' do
      # Define the date for this specific context
      let(:enrollment_date) { Date.new(2025, 8, 20) } # 5 days after deadline

      it 'returns true' do
        expect(enrollment.is_past_application_deadline).to be true
      end
    end
  end
end
