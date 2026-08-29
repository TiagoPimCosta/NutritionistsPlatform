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

ActiveRecord::Schema[8.0].define(version: 2026_08_29_100500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "appointments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "guest_id", null: false
    t.uuid "nutritionist_service_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id", "status"], name: "index_appointments_on_guest_id_and_status"
    t.index ["nutritionist_service_id", "status"], name: "index_appointments_on_nutritionist_service_id_and_status"
    t.index ["starts_at", "ends_at"], name: "index_appointments_on_starts_at_and_ends_at"
    t.check_constraint "ends_at > starts_at", name: "check_appointments_ends_after_starts"
  end

  create_table "guests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_guests_on_lower_email", unique: true
  end

  create_table "nutritionist_services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "nutritionist_id", null: false
    t.uuid "service_id", null: false
    t.string "street", null: false
    t.string "city", null: false
    t.integer "price_cents", null: false
    t.integer "duration_minutes", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_nutritionist_services_on_city"
    t.index ["nutritionist_id", "service_id", "city"], name: "index_nutritionist_services_on_nutritionist_service_city", unique: true
    t.index ["service_id"], name: "index_nutritionist_services_on_service_id"
    t.check_constraint "duration_minutes > 0", name: "check_nutritionist_services_duration_positive"
    t.check_constraint "price_cents > 0", name: "check_nutritionist_services_price_positive"
  end

  create_table "nutritionists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "license_number", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["license_number"], name: "index_nutritionists_on_license_number", unique: true
    t.index ["name"], name: "index_nutritionists_on_name"
  end

  create_table "services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_services_on_name", unique: true
  end

  add_foreign_key "appointments", "guests"
  add_foreign_key "appointments", "nutritionist_services"
  add_foreign_key "nutritionist_services", "nutritionists"
  add_foreign_key "nutritionist_services", "services"
end
