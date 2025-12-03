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

ActiveRecord::Schema[8.1].define(version: 2025_12_03_065125) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_correct", default: false, null: false
    t.bigint "question_id", null: false
    t.bigint "quiz_attempt_id", null: false
    t.bigint "selected_option_id", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "quiz_attempt_id"], name: "unique_question_quiz_attempt", unique: true
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["quiz_attempt_id"], name: "index_answers_on_quiz_attempt_id"
    t.index ["selected_option_id"], name: "index_answers_on_selected_option_id"
  end

  create_table "options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_correct", default: false
    t.text "option_text", null: false
    t.bigint "question_id", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "question_text", null: false
    t.string "question_type", null: false
    t.bigint "quizes_id", null: false
    t.datetime "updated_at", null: false
    t.index ["quizes_id"], name: "index_questions_on_quizes_id"
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.string "participant_email", null: false
    t.string "participant_name", null: false
    t.bigint "quizes_id", null: false
    t.integer "score", default: 0
    t.integer "total_questions", default: 0
    t.datetime "updated_at", null: false
    t.index ["participant_email"], name: "index_quiz_attempts_on_participant_email"
    t.index ["quizes_id"], name: "index_quiz_attempts_on_quizes_id"
  end

  create_table "quizes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.text "description"
    t.boolean "published", default: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_quizes_on_created_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "answers", "options", column: "selected_option_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "quiz_attempts"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "quizes", column: "quizes_id"
  add_foreign_key "quiz_attempts", "quizes", column: "quizes_id"
  add_foreign_key "quizes", "users", column: "created_by_id"
end
