class CreateLessonsTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons_topics, id: false do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
    end
    add_index :lessons_topics, [:lesson_id, :topic_id], unique: true
  end
end