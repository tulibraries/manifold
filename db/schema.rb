# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_23_203933) do

  create_table "accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.boolean "alertability"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "alerts", force: :cascade do |t|
    t.string "scroll_text"
    t.string "link"
    t.text "description"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.string "base_url"
    t.string "feed_path"
    t.datetime "last_sync_date"
    t.boolean "public_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address1"
    t.string "temple_building_code"
    t.string "coordinates"
    t.string "hours"
    t.string "phone_number"
    t.string "campus"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "google_id"
    t.string "address2"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "building_id"
    t.integer "space_id"
    t.string "external_building"
    t.string "external_space"
    t.string "external_address"
    t.string "external_city"
    t.string "external_state"
    t.string "external_zip"
    t.integer "person_id"
    t.string "external_contact_name"
    t.string "external_contact_email"
    t.string "external_contact_phone"
    t.boolean "cancelled"
    t.boolean "registration_status"
    t.string "registration_link"
    t.string "content_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alt_text"
    t.index ["building_id"], name: "index_events_on_building_id"
    t.index ["person_id"], name: "index_events_on_person_id"
    t.index ["space_id"], name: "index_events_on_space_id"
  end

  create_table "group_contacts", force: :cascade do |t|
    t.integer "group_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_contacts_on_group_id"
    t.index ["person_id"], name: "index_group_contacts_on_person_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "phone_number"
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group_type"
    t.boolean "external"
  end

  create_table "highlights", force: :cascade do |t|
    t.string "title"
    t.text "blurb"
    t.string "link"
    t.date "date"
    t.time "time"
    t.string "type_of_highlight"
    t.string "tags"
    t.boolean "promoted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "library_hours", force: :cascade do |t|
    t.string "location"
    t.datetime "date"
    t.string "hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location_id"
  end

  create_table "members", force: :cascade do |t|
    t.integer "group_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_members_on_group_id"
    t.index ["person_id"], name: "index_members_on_person_id"
  end

  create_table "occupants", force: :cascade do |t|
    t.integer "space_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_occupants_on_person_id"
    t.index ["space_id"], name: "index_occupants_on_space_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email_address"
    t.string "chat_handle"
    t.string "job_title"
    t.string "research_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "personal_site"
    t.string "springshare_id"
  end

  create_table "service_groups", force: :cascade do |t|
    t.integer "service_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_service_groups_on_group_id"
    t.index ["service_id"], name: "index_service_groups_on_service_id"
  end

  create_table "service_spaces", force: :cascade do |t|
    t.integer "service_id"
    t.integer "space_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_spaces_on_service_id"
    t.index ["space_id"], name: "index_service_spaces_on_space_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "access_description"
    t.string "access_link"
    t.text "service_policies"
    t.text "intended_audience"
    t.string "service_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "space_groups", force: :cascade do |t|
    t.integer "space_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_space_groups_on_group_id"
    t.index ["space_id"], name: "index_space_groups_on_space_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "hours"
    t.text "accessibility"
    t.string "phone_number"
    t.string "image"
    t.string "email"
    t.integer "building_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_spaces_on_ancestry"
    t.index ["building_id"], name: "index_spaces_on_building_id"
  end

end
