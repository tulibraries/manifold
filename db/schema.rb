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

ActiveRecord::Schema.define(version: 2018_07_06_154230) do

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
    t.string "is_admin"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "building_groups", force: :cascade do |t|
    t.integer "building_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_building_groups_on_building_id"
    t.index ["group_id"], name: "index_building_groups_on_group_id"
  end

  create_table "building_people", force: :cascade do |t|
    t.integer "building_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_building_people_on_building_id"
    t.index ["person_id"], name: "index_building_people_on_person_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address1"
    t.string "temple_building_code"
    t.string "directions_map"
    t.string "hours"
    t.string "phone_number"
    t.string "image"
    t.string "campus"
    t.text "accessibility"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_people", force: :cascade do |t|
    t.integer "group_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_people_on_group_id"
    t.index ["person_id"], name: "index_group_people_on_person_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "phone_number"
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email_address"
    t.string "chat_handle"
    t.string "job_title"
    t.string "identifier"
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

  create_table "space_people", force: :cascade do |t|
    t.integer "space_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_space_people_on_person_id"
    t.index ["space_id"], name: "index_space_people_on_space_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "hours"
    t.text "accessibility"
    t.string "location"
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
