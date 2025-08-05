class Course < ApplicationRecord
  belongs_to :coding_class
  belongs_to :trimester
  has_many :enrollments

  delegate :title, to: :coding_class

  def student_email_list
    enrollments.includes(:student).map { |enrollment| enrollment.student.email }
  end
end
