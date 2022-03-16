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

ActiveRecord::Schema.define(version: 2022_03_15_145459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accountabilities", force: :cascade do |t|
    t.string "accountable_type"
    t.bigint "accountable_id"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "accountable_id", "accountable_type"], name: "polymorphic_accountability", unique: true
    t.index ["account_id"], name: "index_accountabilities_on_account_id"
  end

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
    t.bigint "admin_group_id"
    t.string "name"
    t.index ["admin_group_id"], name: "index_accounts_on_admin_group_id"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "json_attributes"
    t.index ["json_attributes"], name: "index_admin_groups_on_json_attributes", using: :gin
  end

  create_table "alerts", force: :cascade do |t|
    t.string "scroll_text"
    t.string "link"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "for_header"
    t.index ["published"], name: "index_alerts_on_published"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "path"
    t.string "post_guid"
    t.datetime "publication_date"
    t.text "categories"
    t.string "external_author_name"
    t.integer "person_id"
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_hash"
    t.index ["blog_id"], name: "index_blog_posts_on_blog_id"
    t.index ["person_id"], name: "index_blog_posts_on_person_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.string "base_url"
    t.string "feed_path"
    t.datetime "last_sync_date"
    t.boolean "public_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
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
    t.boolean "add_to_footer"
    t.integer "external_link_id"
    t.string "slug"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.index ["external_link_id"], name: "index_buildings_on_external_link_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "custom_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "slug"
    t.bigint "external_link_id"
    t.bigint "menu_group_id"
    t.index ["external_link_id"], name: "index_categories_on_external_link_id"
    t.index ["menu_group_id"], name: "index_categories_on_menu_group_id"
  end

  create_table "categorizations", force: :cascade do |t|
    t.integer "category_id"
    t.string "categorizable_type"
    t.integer "categorizable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 10
    t.index ["category_id", "categorizable_id", "categorizable_type"], name: "polymorphic_categorizations", unique: true
    t.index ["category_id"], name: "index_categorizations_on_category_id"
  end

  create_table "collection_aids", force: :cascade do |t|
    t.integer "collection_id"
    t.integer "finding_aid_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_aids_on_collection_id"
    t.index ["finding_aid_id"], name: "index_collection_aids_on_finding_aid_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.text "subject"
    t.text "contents"
    t.integer "building_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "add_to_footer"
    t.integer "space_id"
    t.bigint "external_link_id"
    t.string "slug"
    t.index ["building_id"], name: "index_collections_on_building_id"
    t.index ["external_link_id"], name: "index_collections_on_external_link_id"
    t.index ["space_id"], name: "index_collections_on_space_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
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
    t.string "ensemble_identifier"
    t.text "tags"
    t.boolean "all_day", default: false
    t.string "event_type"
    t.string "slug"
    t.string "guid"
    t.string "event_url"
    t.boolean "featured"
    t.index ["building_id"], name: "index_events_on_building_id"
    t.index ["person_id"], name: "index_events_on_person_id"
    t.index ["space_id"], name: "index_events_on_space_id"
  end

  create_table "exhibitions", force: :cascade do |t|
    t.string "title"
    t.date "start_date"
    t.date "end_date"
    t.integer "group_id"
    t.integer "space_id"
    t.integer "collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "promoted_to_events"
    t.string "slug"
    t.index ["collection_id"], name: "index_exhibitions_on_collection_id"
    t.index ["group_id"], name: "index_exhibitions_on_group_id"
    t.index ["space_id"], name: "index_exhibitions_on_space_id"
  end

  create_table "external_links", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "file_uploads", force: :cascade do |t|
    t.string "name"
    t.string "attachable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "fileabilities", force: :cascade do |t|
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.bigint "file_upload_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_upload_id", "attachable_id", "attachable_type"], name: "polymorphic_fileability", unique: true
    t.index ["file_upload_id"], name: "index_fileabilities_on_file_upload_id"
  end

  create_table "finding_aid_responsibilities", force: :cascade do |t|
    t.integer "finding_aid_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finding_aid_id"], name: "index_finding_aid_responsibilities_on_finding_aid_id"
    t.index ["person_id"], name: "index_finding_aid_responsibilities_on_person_id"
  end

  create_table "finding_aids", force: :cascade do |t|
    t.string "name"
    t.text "subject"
    t.string "content_link"
    t.string "identifier"
    t.integer "collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "drupal_id"
    t.string "path"
    t.string "slug"
    t.index ["collection_id"], name: "index_finding_aids_on_collection_id"
  end

  create_table "form_submissions", force: :cascade do |t|
    t.text "form_attributes_ciphertext"
    t.string "form_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
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
    t.string "phone_number"
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group_type"
    t.boolean "external"
    t.boolean "add_to_footer"
    t.integer "parent_group_id"
    t.string "slug"
    t.index ["parent_group_id"], name: "index_groups_on_parent_group_id"
  end

  create_table "highlights", force: :cascade do |t|
    t.string "title"
    t.text "blurb"
    t.string "link"
    t.string "type_of_highlight"
    t.string "tags"
    t.boolean "promoted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link_label"
    t.string "slug"
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

  create_table "menu_group_categories", force: :cascade do |t|
    t.integer "menu_group_id"
    t.integer "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "menu_groups", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "occupants", force: :cascade do |t|
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "building_id"
    t.index ["building_id"], name: "index_occupants_on_building_id"
    t.index ["person_id"], name: "index_occupants_on_person_id"
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
    t.string "specialties"
    t.string "libguides_account"
    t.string "slug"
    t.string "pronouns"
    t.bigint "building_id"
    t.index ["building_id"], name: "index_people_on_building_id"
  end

  create_table "policies", force: :cascade do |t|
    t.string "name"
    t.date "effective_date"
    t.date "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "slug"
  end

  create_table "policy_applications", force: :cascade do |t|
    t.string "policyable_type"
    t.integer "policyable_id"
    t.integer "policy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["policy_id"], name: "index_policy_applications_on_policy_id"
    t.index ["policyable_type", "policyable_id", "policy_id"], name: "index_uniqueness_policy_application", unique: true
  end

  create_table "redirects", force: :cascade do |t|
    t.string "legacy_path"
    t.string "manifold_path"
    t.string "redirectable_type"
    t.bigint "redirectable_id"
    t.boolean "no_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["legacy_path"], name: "index_redirects_on_legacy_path", unique: true
    t.index ["redirectable_type", "redirectable_id"], name: "index_redirects_on_redirectable_type_and_redirectable_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "title"
    t.text "service_policies"
    t.text "intended_audience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hours"
    t.integer "external_link_id"
    t.string "slug"
    t.index ["external_link_id"], name: "index_services_on_external_link_id"
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
    t.string "hours"
    t.string "phone_number"
    t.string "image"
    t.string "email"
    t.integer "building_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.bigint "external_link_id"
    t.string "slug"
    t.index ["ancestry"], name: "index_spaces_on_ancestry"
    t.index ["building_id"], name: "index_spaces_on_building_id"
    t.index ["external_link_id"], name: "index_spaces_on_external_link_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "webpages", force: :cascade do |t|
    t.string "title"
    t.string "layout"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "external_link_id"
    t.string "virtual_tour"
    t.index ["external_link_id"], name: "index_webpages_on_external_link_id"
    t.index ["group_id"], name: "index_webpages_on_group_id"
  end

  add_foreign_key "accounts", "admin_groups"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "external_links"
  add_foreign_key "categories", "menu_groups"
  add_foreign_key "collections", "external_links"
  add_foreign_key "occupants", "buildings"
  add_foreign_key "people", "buildings"
  add_foreign_key "spaces", "external_links"
  add_foreign_key "webpages", "external_links"
end
