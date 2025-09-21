# File path: ~/code/ltphongssvn/rails-dream-of-code-app/app/models/student.rb
class Student < ApplicationRecord
  has_secure_password
  
  has_many :enrollments
  
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
