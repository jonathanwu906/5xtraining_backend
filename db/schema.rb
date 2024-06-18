ActiveRecord::Schema[7.1].define(version: 2024_06_18_042335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tasks", force: :cascade do |t|
    t.string "name", null: false
    t.text "content", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.integer "priority", null: false
    t.integer "status", null: false
    t.string "label"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tasks_on_name"
    t.index ["status"], name: "index_tasks_on_status"
    t.index ["user_id"], name: "index_tasks_on_user_id"
    t.check_constraint "char_length(content) <= 1000", name: "content_length_check"
    t.check_constraint "char_length(label::text) <= 30", name: "label_length_check"
    t.check_constraint "char_length(name::text) <= 255", name: "name_length_check"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "tasks", "users"
end
