# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_08_005907) do
  create_table "categories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "color"
    t.integer "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "coding_classes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.integer "coding_class_id", null: false
    t.integer "trimester_id", null: false
    t.integer "max_enrollment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coding_class_id"], name: "index_courses_on_coding_class_id"
    t.index ["trimester_id"], name: "index_courses_on_trimester_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "student_id", null: false
    t.string "final_grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "lesson_number"
    t.string "title"
    t.string "url"
    t.date "assignment_due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "mentor_enrollment_assignments", force: :cascade do |t|
    t.integer "mentor_id", null: false
    t.integer "enrollment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enrollment_id"], name: "index_mentor_enrollment_assignments_on_enrollment_id"
    t.index ["mentor_id"], name: "index_mentor_enrollment_assignments_on_mentor_id"
  end

  create_table "mentors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.integer "max_concurrent_students"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "category_id", null: false
    t.date "date"
    t.integer "hour"
    t.integer "duration_minutes"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_time_entries_on_category_id"
    t.index ["user_id"], name: "index_time_entries_on_user_id"
  end

  create_table "trimesters", force: :cascade do |t|
    t.string "year"
    t.string "term"
    t.date "application_deadline"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.string "first_name"
    t.string "last_name"
    t.string "time_zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categories", "users"
  add_foreign_key "courses", "coding_classes"
  add_foreign_key "courses", "trimesters"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "students"
  add_foreign_key "lessons", "courses"
  add_foreign_key "mentor_enrollment_assignments", "enrollments"
  add_foreign_key "mentor_enrollment_assignments", "mentors"
  add_foreign_key "time_entries", "categories"
  add_foreign_key "time_entries", "users"
end
