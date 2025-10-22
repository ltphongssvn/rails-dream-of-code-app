class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :category
  
  # Validations to ensure time tracking data integrity
  validates :date, presence: true
  validates :duration_minutes, presence: true, 
                               numericality: { only_integer: true, 
                                             greater_than: 0,
                                             less_than_or_equal_to: 1440,
                                             message: "must be between 1 and 1440 minutes (24 hours)" }
  validates :hour, numericality: { only_integer: true, 
                                   in: 0..23,
                                   message: "must be between 0 and 23" }, 
                   allow_nil: true
  
  # Optional validation for notes field if it exists
  validates :notes, length: { maximum: 500 }, allow_blank: true
end
