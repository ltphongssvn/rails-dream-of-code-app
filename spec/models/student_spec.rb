require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'validations' do
    it 'is valid with first_name, last_name, and email' do
      student = Student.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com'
      )
      expect(student).to be_valid
    end

    it 'is invalid without a first_name' do
      student = Student.new(
        last_name: 'Doe',
        email: 'john.doe@example.com'
      )
      expect(student).not_to be_valid
      expect(student.errors[:first_name]).to include("can't be blank")
    end

    it 'is invalid without a last_name' do
      student = Student.new(
        first_name: 'John',
        email: 'john.doe@example.com'
      )
      expect(student).not_to be_valid
      expect(student.errors[:last_name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      student = Student.new(
        first_name: 'John',
        last_name: 'Doe'
      )
      expect(student).not_to be_valid
      expect(student.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      Student.create!(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com'
      )

      duplicate_student = Student.new(
        first_name: 'Jane',
        last_name: 'Smith',
        email: 'john.doe@example.com'
      )
      expect(duplicate_student).not_to be_valid
      expect(duplicate_student.errors[:email]).to include('has already been taken')
    end
  end

  describe '#full_name' do
    it 'returns the full name as first_name + last_name' do
      student = Student.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com'
      )
      expect(student.full_name).to eq('John Doe')
    end
  end
end
