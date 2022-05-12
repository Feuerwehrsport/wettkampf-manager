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

ActiveRecord::Schema.define(version: 2022_05_11_212628) do

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

  create_table "api_time_entries", force: :cascade do |t|
    t.integer "time", null: false
    t.string "hint"
    t.string "sender"
    t.datetime "used_at"
    t.integer "score_list_entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assessment_requests", force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.string "entity_type", null: false
    t.integer "entity_id", null: false
    t.integer "assessment_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_competitor_order", default: 0, null: false
    t.integer "relay_count", default: 1, null: false
    t.integer "single_competitor_order", default: 0, null: false
    t.integer "competitor_order", default: 0, null: false
    t.index ["assessment_id"], name: "index_assessment_requests_on_assessment_id"
    t.index ["entity_type", "entity_id"], name: "index_assessment_requests_on_entity_type_and_entity_id"
  end

  create_table "assessments", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "discipline_id", null: false
    t.integer "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score_competition_result_id"
    t.index ["discipline_id"], name: "index_assessments_on_discipline_id"
    t.index ["score_competition_result_id"], name: "index_assessments_on_score_competition_result_id"
  end

  create_table "certificates_templates", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "certificates_text_fields", force: :cascade do |t|
    t.integer "template_id", null: false
    t.decimal "left", null: false
    t.decimal "top", null: false
    t.decimal "width", null: false
    t.decimal "height", null: false
    t.integer "size", null: false
    t.string "key", null: false
    t.string "align", null: false
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "font", default: "regular", null: false
    t.string "color", default: "000000", null: false
    t.index ["template_id"], name: "index_certificates_text_fields_on_template_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.date "date", null: false
    t.boolean "configured", default: false, null: false
    t.boolean "group_assessment", default: false, null: false
    t.integer "group_people_count", default: 10, null: false
    t.integer "group_run_count", default: 8, null: false
    t.integer "group_score_count", default: 6, null: false
    t.boolean "show_bib_numbers", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hostname", default: "", null: false
    t.string "competition_result_type"
    t.string "place", default: "", null: false
    t.text "flyer_text", default: "", null: false
    t.string "backup_path", default: "", null: false
    t.boolean "lottery_numbers", default: false, null: false
    t.string "flyer_headline"
    t.boolean "hide_competition_results", default: false, null: false
    t.boolean "federal_states", default: false, null: false
  end

  create_table "disciplines", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "short_name", default: "", null: false
    t.boolean "like_fire_relay", default: false, null: false
  end

  create_table "federal_states", force: :cascade do |t|
    t.string "name", null: false
    t.string "shortcut", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fire_sport_statistics_people", force: :cascade do |t|
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.integer "gender", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "dummy", default: false, null: false
    t.integer "personal_best_hb"
    t.string "personal_best_hb_competition"
    t.integer "personal_best_hl"
    t.string "personal_best_hl_competition"
    t.integer "personal_best_zk"
    t.string "personal_best_zk_competition"
    t.integer "saison_best_hb"
    t.string "saison_best_hb_competition"
    t.integer "saison_best_hl"
    t.string "saison_best_hl_competition"
    t.integer "saison_best_zk"
    t.string "saison_best_zk_competition"
  end

  create_table "fire_sport_statistics_person_spellings", force: :cascade do |t|
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.integer "gender", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_fire_sport_statistics_person_spellings_on_person_id"
  end

  create_table "fire_sport_statistics_team_associations", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_fire_sport_statistics_team_associations_on_person_id"
    t.index ["team_id"], name: "index_fire_sport_statistics_team_associations_on_team_id"
  end

  create_table "fire_sport_statistics_team_spellings", force: :cascade do |t|
    t.string "name", null: false
    t.string "short", null: false
    t.integer "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_fire_sport_statistics_team_spellings_on_team_id"
  end

  create_table "fire_sport_statistics_teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "short", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "dummy", default: false, null: false
    t.integer "federal_state_id"
    t.index ["federal_state_id"], name: "index_fire_sport_statistics_teams_on_federal_state_id"
  end

  create_table "imports_assessments", force: :cascade do |t|
    t.integer "foreign_key", null: false
    t.integer "configuration_id"
    t.string "name"
    t.string "gender"
    t.string "discipline"
    t.integer "assessment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_imports_assessments_on_assessment_id"
    t.index ["configuration_id"], name: "index_imports_assessments_on_configuration_id"
    t.index ["foreign_key"], name: "index_imports_assessments_on_foreign_key"
  end

  create_table "imports_configurations", force: :cascade do |t|
    t.datetime "executed_at"
    t.text "data", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imports_tags", force: :cascade do |t|
    t.integer "configuration_id", null: false
    t.string "name", null: false
    t.string "target", null: false
    t.boolean "use", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["configuration_id"], name: "index_imports_tags_on_configuration_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.integer "gender", null: false
    t.integer "team_id"
    t.string "bib_number", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fire_sport_statistics_person_id"
    t.integer "registration_order", default: 0, null: false
    t.index ["team_id"], name: "index_people_on_team_id"
  end

  create_table "score_competition_results", force: :cascade do |t|
    t.string "name"
    t.integer "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "result_type"
  end

  create_table "score_list_assessments", force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.integer "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_list_entries", force: :cascade do |t|
    t.integer "list_id", null: false
    t.string "entity_type", null: false
    t.integer "entity_id", null: false
    t.integer "track", null: false
    t.integer "run", null: false
    t.string "result_type", default: "waiting", null: false
    t.integer "assessment_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assessment_id", null: false
    t.integer "time"
    t.index ["list_id"], name: "index_score_list_entries_on_list_id"
  end

  create_table "score_list_factories", force: :cascade do |t|
    t.string "session_id"
    t.integer "discipline_id", null: false
    t.string "name"
    t.string "shortcut"
    t.integer "track_count"
    t.string "type"
    t.integer "before_result_id"
    t.integer "before_list_id"
    t.integer "best_count"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "track"
    t.integer "gender"
    t.boolean "hidden", default: false, null: false
  end

  create_table "score_list_factory_assessments", force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.integer "list_factory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_score_list_factory_assessments_on_assessment_id"
    t.index ["list_factory_id"], name: "index_score_list_factory_assessments_on_list_factory_id"
  end

  create_table "score_lists", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "track_count", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shortcut", default: "", null: false
    t.date "date"
    t.boolean "show_multiple_assessments", default: true
    t.boolean "hidden", default: false, null: false
  end

  create_table "score_result_list_factories", force: :cascade do |t|
    t.integer "list_factory_id", null: false
    t.integer "result_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_factory_id"], name: "index_score_result_list_factories_on_list_factory_id"
    t.index ["result_id"], name: "index_score_result_list_factories_on_result_id"
  end

  create_table "score_result_lists", force: :cascade do |t|
    t.integer "list_id", null: false
    t.integer "result_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_score_result_lists_on_list_id"
    t.index ["result_id"], name: "index_score_result_lists_on_result_id"
  end

  create_table "score_results", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.boolean "group_assessment", default: false, null: false
    t.integer "assessment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "double_event_result_id"
    t.string "type", default: "Score::Result", null: false
    t.integer "group_score_count"
    t.integer "group_run_count"
    t.date "date"
    t.index ["assessment_id"], name: "index_score_results_on_assessment_id"
    t.index ["double_event_result_id"], name: "index_score_results_on_double_event_result_id"
  end

  create_table "series_assessment_results", force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.integer "score_result_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_series_assessment_results_on_assessment_id"
    t.index ["score_result_id"], name: "index_series_assessment_results_on_score_result_id"
  end

  create_table "series_assessments", force: :cascade do |t|
    t.integer "round_id", null: false
    t.string "discipline", null: false
    t.string "name", default: "", null: false
    t.string "type", null: false
    t.integer "gender", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "series_cups", force: :cascade do |t|
    t.integer "round_id", null: false
    t.string "competition_place", null: false
    t.date "competition_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "series_participations", force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.integer "cup_id", null: false
    t.string "type", null: false
    t.integer "team_id"
    t.integer "team_number"
    t.integer "person_id"
    t.integer "time", null: false
    t.integer "points", default: 0, null: false
    t.integer "rank", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "series_rounds", force: :cascade do |t|
    t.string "name", null: false
    t.integer "year", null: false
    t.string "aggregate_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "full_cup_count", default: 4, null: false
  end

  create_table "tag_references", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.string "taggable_type", null: false
    t.integer "taggable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.integer "competition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_relays", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "number", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_relays_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.integer "gender", null: false
    t.integer "number", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shortcut", default: "", null: false
    t.integer "fire_sport_statistics_team_id"
    t.integer "lottery_number"
    t.integer "federal_state_id"
    t.boolean "enrolled", default: false, null: false
    t.index ["federal_state_id"], name: "index_teams_on_federal_state_id"
    t.index ["fire_sport_statistics_team_id"], name: "index_teams_on_fire_sport_statistics_team_id"
    t.index ["name", "number", "gender"], name: "index_teams_on_name_and_number_and_gender", unique: true
  end

  create_table "user_assessment_abilities", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "assessment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_user_assessment_abilities_on_assessment_id"
    t.index ["user_id"], name: "index_user_assessment_abilities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "password_hash"
    t.string "password_salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
