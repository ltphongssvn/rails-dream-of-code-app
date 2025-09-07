class Lesson < ApplicationRecord
  belongs_to :course

  # Many-to-many relationship with topics
  has_many :lessons_topics
  has_many :topics, through: :lessons_topics
end
