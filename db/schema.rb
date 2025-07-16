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

ActiveRecord::Schema[8.0].define(version: 2025_07_16_123242) do
  create_table "events", force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "event_name", null: false
    t.json "properties"
    t.string "page_url"
    t.string "referrer"
    t.string "user_agent"
    t.string "ip_address"
    t.boolean "is_bot", default: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_events_on_created_at"
    t.index ["event_name"], name: "index_events_on_event_name"
    t.index ["is_bot"], name: "index_events_on_is_bot"
    t.index ["site_id"], name: "index_events_on_site_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name", null: false
    t.string "domain", null: false
    t.string "tracking_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_sites_on_domain", unique: true
    t.index ["tracking_id"], name: "index_sites_on_tracking_id", unique: true
    t.index ["user_id"], name: "index_sites_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "events", "sites"
  add_foreign_key "sessions", "users"
  add_foreign_key "sites", "users"
end
