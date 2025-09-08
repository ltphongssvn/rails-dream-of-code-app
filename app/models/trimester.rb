# File path:
# ~/code/ltphongssvn/code-the-dream-knifejaw-rails/practice/ThanhPhongLe/week-01/rails-dream-of-code-app/app/models/trimester.rb
# Trimester model with display_name method using hyphen format to match test expectations
class Trimester < ApplicationRecord
  has_many :courses

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :application_deadline, presence: true

  def display_name
    "#{term}-#{year}"
  end
end
