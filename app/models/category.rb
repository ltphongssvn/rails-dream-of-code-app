class Category < ApplicationRecord
  belongs_to :user
  
  # Validations to ensure data integrity
  validates :name, presence: true, length: { maximum: 100 }
  validates :color, format: { with: /\A#[0-9A-Fa-f]{3,6}\z/, 
                              message: "must be a valid hex color code" }, 
                    allow_blank: true
end
