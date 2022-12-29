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

ActiveRecord::Schema[7.0].define(version: 2022_12_29_035743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "administrators", force: :cascade do |t|
    t.bigint "company_id"
    t.string "email", default: "", null: false
    t.string "phone_number"
    t.string "name"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "otp_auth_secret"
    t.string "otp_recovery_secret"
    t.boolean "otp_enabled", default: false, null: false
    t.boolean "otp_mandatory", default: false, null: false
    t.datetime "otp_enabled_on"
    t.integer "otp_failed_attempts", default: 0, null: false
    t.integer "otp_recovery_counter", default: 0, null: false
    t.string "otp_persistence_seed"
    t.string "otp_session_challenge"
    t.datetime "otp_challenge_expires"
    t.index ["company_id"], name: "index_administrators_on_company_id"
    t.index ["confirmation_token"], name: "index_administrators_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_administrators_on_deleted_at"
    t.index ["email", "company_id"], name: "index_administrators_on_email_and_company_id", unique: true
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["otp_challenge_expires"], name: "index_administrators_on_otp_challenge_expires"
    t.index ["otp_session_challenge"], name: "index_administrators_on_otp_session_challenge", unique: true
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_administrators_on_unlock_token", unique: true
  end

  create_table "backup_queues", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "counter_id"
    t.bigint "service_id"
    t.date "date"
    t.string "letter"
    t.integer "number"
    t.string "service_type_slug"
    t.datetime "print_ticket_time"
    t.string "print_ticket_location"
    t.string "print_ticket_method"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.boolean "priority", default: false
    t.string "uniq_number"
    t.boolean "attend", default: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "process_duration"
    t.index ["counter_id"], name: "index_backup_queues_on_counter_id"
    t.index ["deleted_at"], name: "index_backup_queues_on_deleted_at"
    t.index ["number", "date", "service_id", "letter"], name: "index_backup_queues_on_number_and_date_and_service_and_letter", unique: true
    t.index ["parent_id"], name: "index_backup_queues_on_parent_id"
    t.index ["service_id"], name: "index_backup_queues_on_service_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["company_id", "name"], name: "index_buildings_on_company_id_and_name", unique: true
    t.index ["company_id"], name: "index_buildings_on_company_id"
    t.index ["deleted_at"], name: "index_buildings_on_deleted_at"
  end

  create_table "client_displays", force: :cascade do |t|
    t.bigint "building_id"
    t.string "client_display_type"
    t.string "ip_address"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["building_id"], name: "index_client_displays_on_building_id"
    t.index ["deleted_at"], name: "index_client_displays_on_deleted_at"
    t.index ["ip_address", "building_id"], name: "index_client_displays_on_ip_address_and_building_id", unique: true
  end

  create_table "closing_days", force: :cascade do |t|
    t.string "closeable_type"
    t.bigint "closeable_id"
    t.date "date"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["closeable_type", "closeable_id"], name: "index_closing_days_on_closeable"
    t.index ["date", "closeable_id", "closeable_type"], name: "index_closing_days_on_date_and_closeable_id_and_closeable_type", unique: true
    t.index ["deleted_at"], name: "index_closing_days_on_deleted_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "latitude"
    t.string "longitude"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_companies_on_deleted_at"
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "counters", force: :cascade do |t|
    t.bigint "service_id"
    t.integer "number", default: 0
    t.boolean "closed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_counters_on_deleted_at"
    t.index ["number", "service_id"], name: "index_counters_on_number_and_service_id", unique: true
    t.index ["service_id"], name: "index_counters_on_service_id"
  end

  create_table "file_storages", force: :cascade do |t|
    t.string "file_able_type"
    t.bigint "file_able_id"
    t.bigint "company_id"
    t.string "title"
    t.string "file_type"
    t.datetime "deleted_at"
    t.index ["company_id"], name: "index_file_storages_on_company_id"
    t.index ["file_able_type", "file_able_id"], name: "index_file_storages_on_file_able"
  end

  create_table "permisi_actor_roles", force: :cascade do |t|
    t.bigint "actor_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["actor_id", "role_id"], name: "index_permisi_actor_roles_on_actor_id_and_role_id", unique: true
    t.index ["actor_id"], name: "index_permisi_actor_roles_on_actor_id"
    t.index ["deleted_at"], name: "index_permisi_actor_roles_on_deleted_at"
    t.index ["role_id"], name: "index_permisi_actor_roles_on_role_id"
  end

  create_table "permisi_actors", force: :cascade do |t|
    t.string "aka_type"
    t.bigint "aka_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["aka_type", "aka_id"], name: "index_permisi_actors_on_aka"
    t.index ["aka_type", "aka_id"], name: "index_permisi_actors_on_aka_type_and_aka_id"
    t.index ["deleted_at"], name: "index_permisi_actors_on_deleted_at"
  end

  create_table "permisi_roles", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.json "permissions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_permisi_roles_on_deleted_at"
  end

  create_table "play_lists", force: :cascade do |t|
    t.bigint "client_display_id"
    t.boolean "playing", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["client_display_id"], name: "index_play_lists_on_client_display_id"
    t.index ["deleted_at"], name: "index_play_lists_on_deleted_at"
  end

  create_table "satisfaction_indices", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.integer "order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["company_id"], name: "index_satisfaction_indices_on_company_id"
    t.index ["deleted_at"], name: "index_satisfaction_indices_on_deleted_at"
    t.index ["name", "company_id"], name: "index_satisfaction_indices_on_name_and_company_id", unique: true
    t.index ["order_number", "company_id"], name: "index_satisfaction_indices_on_order_number_and_company_id", unique: true
  end

  create_table "service_types", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["company_id", "name"], name: "index_service_types_on_company_id_and_name", unique: true
    t.index ["company_id"], name: "index_service_types_on_company_id"
    t.index ["deleted_at"], name: "index_service_types_on_deleted_at"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "service_type_id"
    t.bigint "parent_id", default: 0
    t.string "name"
    t.string "letter"
    t.boolean "priority", default: false
    t.boolean "active", default: true
    t.integer "max_quota"
    t.boolean "closed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "max_service_time"
    t.index ["company_id"], name: "index_services_on_company_id"
    t.index ["deleted_at"], name: "index_services_on_deleted_at"
    t.index ["letter", "company_id"], name: "index_services_on_letter_and_company_id", unique: true
    t.index ["parent_id"], name: "index_services_on_parent_id"
    t.index ["service_type_id"], name: "index_services_on_service_type_id"
  end

  create_table "shared_clientdisplays", force: :cascade do |t|
    t.string "clientdisplay_able_type"
    t.bigint "clientdisplay_able_id"
    t.bigint "client_display_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["client_display_id"], name: "index_shared_clientdisplays_on_client_display_id"
    t.index ["clientdisplay_able_id", "clientdisplay_able_type"], name: "index_shared_clientdisplays_on_client_display", unique: true
    t.index ["clientdisplay_able_type", "clientdisplay_able_id"], name: "index_shared_clientdisplays_on_clientdisplay_able"
    t.index ["deleted_at"], name: "index_shared_clientdisplays_on_deleted_at"
  end

  create_table "today_queues", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "counter_id"
    t.bigint "service_id"
    t.date "date"
    t.string "letter"
    t.integer "number"
    t.string "service_type_slug"
    t.datetime "print_ticket_time"
    t.string "print_ticket_location"
    t.string "print_ticket_method"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.boolean "priority", default: false
    t.string "uniq_number"
    t.boolean "attend", default: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "process_duration"
    t.index ["counter_id"], name: "index_today_queues_on_counter_id"
    t.index ["deleted_at"], name: "index_today_queues_on_deleted_at"
    t.index ["number", "date", "service_id", "letter"], name: "index_today_queues_on_number_and_date_and_service_id_and_letter", unique: true
    t.index ["parent_id"], name: "index_today_queues_on_parent_id"
    t.index ["service_id"], name: "index_today_queues_on_service_id"
  end

  create_table "user_counters", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "counter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["counter_id"], name: "index_user_counters_on_counter_id"
    t.index ["deleted_at"], name: "index_user_counters_on_deleted_at"
    t.index ["user_id", "counter_id"], name: "index_user_counters_on_user_id_and_counter_id", unique: true
    t.index ["user_id"], name: "index_user_counters_on_user_id"
  end

  create_table "user_satisfaction_indices", force: :cascade do |t|
    t.bigint "today_queue_id"
    t.bigint "satisfaction_index_id"
    t.string "satifcation_index_name"
    t.string "officer_name"
    t.integer "rating"
    t.string "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_satisfaction_indices_on_deleted_at"
    t.index ["satisfaction_index_id", "today_queue_id"], name: "index_user_satisfaction_indices_on_satisfaction_and_queue", unique: true
    t.index ["satisfaction_index_id"], name: "index_user_satisfaction_indices_on_satisfaction_index_id"
    t.index ["today_queue_id"], name: "index_user_satisfaction_indices_on_today_queue_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "phone_number"
    t.string "name"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "refresh_token"
    t.datetime "refresh_token_created_at"
    t.string "otp_auth_secret"
    t.string "otp_recovery_secret"
    t.boolean "otp_enabled", default: false, null: false
    t.boolean "otp_mandatory", default: false, null: false
    t.datetime "otp_enabled_on"
    t.integer "otp_failed_attempts", default: 0, null: false
    t.integer "otp_recovery_counter", default: 0, null: false
    t.string "otp_persistence_seed"
    t.string "otp_session_challenge"
    t.datetime "otp_challenge_expires"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["otp_challenge_expires"], name: "index_users_on_otp_challenge_expires"
    t.index ["otp_session_challenge"], name: "index_users_on_otp_session_challenge", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_versions_on_deleted_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "voice_overs", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_voice_overs_on_deleted_at"
    t.index ["name"], name: "index_voice_overs_on_name", unique: true
  end

  create_table "voiceover_buildings", force: :cascade do |t|
    t.bigint "building_id"
    t.bigint "voice_over_id"
    t.integer "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["building_id"], name: "index_voiceover_buildings_on_building_id"
    t.index ["deleted_at"], name: "index_voiceover_buildings_on_deleted_at"
    t.index ["voice_over_id", "building_id", "day"], name: "index_voiceover_buildings_on_voice_over_and_building_and_day", unique: true
    t.index ["voice_over_id"], name: "index_voiceover_buildings_on_voice_over_id"
  end

  create_table "working_days", force: :cascade do |t|
    t.string "workable_type"
    t.bigint "workable_id"
    t.integer "day"
    t.time "open_time"
    t.time "closing_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["day", "workable_id", "workable_type"], name: "index_working_days_on_day_and_workable_id_and_workable_type", unique: true
    t.index ["deleted_at"], name: "index_working_days_on_deleted_at"
    t.index ["workable_type", "workable_id"], name: "index_working_days_on_workable"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
