# File path: ~/code/ltphongssvn/rails-dream-of-code-app/app/models/mentor.rb
class Mentor < ApplicationRecord
  has_secure_password
  
  has_many :mentor_enrollment_assignments
  
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
end
