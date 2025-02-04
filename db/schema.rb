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

ActiveRecord::Schema[8.0].define(version: 2025_02_04_083228) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.decimal "price", precision: 10, scale: 2
    t.integer "category", null: false
    t.bigint "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "miscs", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "otp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_miscs_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "client_id"
    t.integer "amount", null: false
    t.string "payment_method", null: false
    t.string "payment_intent_id", null: false
    t.string "status", null: false
    t.datetime "paid_at"
    t.datetime "failed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_payments_on_client_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.integer "category", null: false
    t.string "fssai_licence", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "riders", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.string "driving_licence", null: false
    t.string "vehical_number", null: false
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "entryable_type", null: false
    t.bigint "entryable_id", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "phone", null: false
    t.text "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "verified_tag", default: false
    t.index ["entryable_type", "entryable_id"], name: "index_users_on_entryable"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
