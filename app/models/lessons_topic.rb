class LessonsTopic < ApplicationRecord
  # This join model creates the many-to-many relationship between lessons and topics
  # Each record represents one topic being covered by one lesson

  belongs_to :lesson
  belongs_to :topic
end