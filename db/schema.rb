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

ActiveRecord::Schema[8.0].define(version: 2025_01_23_132306) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "miscs", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "otp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_miscs_on_user_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.integer "category", null: false
    t.string "fssai_licence", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "riders", force: :cascade do |t|
    t.integer "status", null: false, default: 1
    t.string "driving_licence", null: false
    t.string "vehical_number", null: false
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "entryable_type", null: false
    t.bigint "entryable_id", null: false
    t.string "name"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "phone", null: false
    t.text "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified_tag", default: false
    t.index ["entryable_type", "entryable_id"], name: "index_users_on_entryable"
  end
end
