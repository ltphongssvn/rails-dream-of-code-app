class Topic < ApplicationRecord
  # This model represents educational topics that can be associated with lessons
  # Each topic has a unique title like "SQL", "Data Modeling", etc.

  # Many-to-many relationship with lessons
  has_many :lessons_topics
  has_many :lessons, through: :lessons_topics
end