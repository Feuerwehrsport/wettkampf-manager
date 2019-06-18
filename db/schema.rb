# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20190618090700) do

  create_table "api_time_entries", force: :cascade do |t|
    t.integer  "time",                null: false
    t.string   "hint"
    t.string   "sender"
    t.datetime "used_at"
    t.integer  "score_list_entry_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "assessment_requests", force: :cascade do |t|
    t.integer  "assessment_id",                       null: false
    t.integer  "entity_id",                           null: false
    t.string   "entity_type",                         null: false
    t.integer  "assessment_type",         default: 0, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "group_competitor_order",  default: 0, null: false
    t.integer  "relay_count",             default: 1, null: false
    t.integer  "single_competitor_order", default: 0, null: false
    t.integer  "competitor_order",        default: 0, null: false
  end

  add_index "assessment_requests", ["assessment_id"], name: "index_assessment_requests_on_assessment_id"
  add_index "assessment_requests", ["entity_type", "entity_id"], name: "index_assessment_requests_on_entity_type_and_entity_id"

  create_table "assessments", force: :cascade do |t|
    t.string   "name",                        default: "", null: false
    t.integer  "discipline_id",                            null: false
    t.integer  "gender"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "score_competition_result_id"
  end

  add_index "assessments", ["discipline_id"], name: "index_assessments_on_discipline_id"
  add_index "assessments", ["score_competition_result_id"], name: "index_assessments_on_score_competition_result_id"

  create_table "certificates_templates", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "image"
    t.string   "font"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "font2"
  end

  create_table "certificates_text_fields", force: :cascade do |t|
    t.integer  "template_id",                     null: false
    t.decimal  "left",                            null: false
    t.decimal  "top",                             null: false
    t.decimal  "width",                           null: false
    t.decimal  "height",                          null: false
    t.integer  "size",                            null: false
    t.string   "key",                             null: false
    t.string   "align",                           null: false
    t.string   "text"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "font",        default: "regular", null: false
  end

  add_index "certificates_text_fields", ["template_id"], name: "index_certificates_text_fields_on_template_id"

  create_table "competitions", force: :cascade do |t|
    t.string   "name",                     default: "",    null: false
    t.date     "date",                                     null: false
    t.boolean  "configured",               default: false, null: false
    t.boolean  "group_assessment",         default: false, null: false
    t.integer  "group_people_count",       default: 10,    null: false
    t.integer  "group_run_count",          default: 8,     null: false
    t.integer  "group_score_count",        default: 6,     null: false
    t.boolean  "show_bib_numbers",         default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "hostname",                 default: "",    null: false
    t.string   "competition_result_type"
    t.string   "place",                    default: "",    null: false
    t.text     "flyer_text",               default: "",    null: false
    t.string   "backup_path",              default: "",    null: false
    t.boolean  "lottery_numbers",          default: false, null: false
    t.string   "flyer_headline"
    t.boolean  "hide_competition_results", default: false, null: false
  end

  create_table "disciplines", force: :cascade do |t|
    t.string   "name",            default: "",    null: false
    t.string   "type",                            null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "short_name",      default: "",    null: false
    t.boolean  "like_fire_relay", default: false, null: false
  end

  create_table "federal_states", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "shortcut",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fire_sport_statistics_people", force: :cascade do |t|
    t.string   "last_name",                  null: false
    t.string   "first_name",                 null: false
    t.integer  "gender",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "dummy",      default: false, null: false
  end

  create_table "fire_sport_statistics_person_spellings", force: :cascade do |t|
    t.string   "last_name",  null: false
    t.string   "first_name", null: false
    t.integer  "gender",     null: false
    t.integer  "person_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fire_sport_statistics_person_spellings", ["person_id"], name: "index_fire_sport_statistics_person_spellings_on_person_id"

  create_table "fire_sport_statistics_team_associations", force: :cascade do |t|
    t.integer  "person_id",  null: false
    t.integer  "team_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fire_sport_statistics_team_associations", ["person_id"], name: "index_fire_sport_statistics_team_associations_on_person_id"
  add_index "fire_sport_statistics_team_associations", ["team_id"], name: "index_fire_sport_statistics_team_associations_on_team_id"

  create_table "fire_sport_statistics_team_spellings", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "short",      null: false
    t.integer  "team_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fire_sport_statistics_team_spellings", ["team_id"], name: "index_fire_sport_statistics_team_spellings_on_team_id"

  create_table "fire_sport_statistics_teams", force: :cascade do |t|
    t.string   "name",                             null: false
    t.string   "short",                            null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "dummy",            default: false, null: false
    t.integer  "federal_state_id"
  end

  add_index "fire_sport_statistics_teams", ["federal_state_id"], name: "index_fire_sport_statistics_teams_on_federal_state_id"

  create_table "imports_assessments", force: :cascade do |t|
    t.integer  "foreign_key",      null: false
    t.integer  "configuration_id"
    t.string   "name"
    t.string   "gender"
    t.string   "discipline"
    t.integer  "assessment_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "imports_assessments", ["assessment_id"], name: "index_imports_assessments_on_assessment_id"
  add_index "imports_assessments", ["configuration_id"], name: "index_imports_assessments_on_configuration_id"
  add_index "imports_assessments", ["foreign_key"], name: "index_imports_assessments_on_foreign_key"

  create_table "imports_configurations", force: :cascade do |t|
    t.string   "file",                       null: false
    t.datetime "executed_at"
    t.text     "data",        default: "{}", null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "imports_tags", force: :cascade do |t|
    t.integer  "configuration_id",                null: false
    t.string   "name",                            null: false
    t.string   "target",                          null: false
    t.boolean  "use",              default: true, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "imports_tags", ["configuration_id"], name: "index_imports_tags_on_configuration_id"

  create_table "people", force: :cascade do |t|
    t.string   "last_name",                                    null: false
    t.string   "first_name",                                   null: false
    t.integer  "gender",                                       null: false
    t.integer  "team_id"
    t.string   "bib_number",                      default: "", null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "fire_sport_statistics_person_id"
    t.integer  "registration_order",              default: 0,  null: false
  end

  add_index "people", ["team_id"], name: "index_people_on_team_id"

  create_table "score_competition_results", force: :cascade do |t|
    t.string   "name"
    t.integer  "gender"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "result_type"
  end

  create_table "score_list_assessments", force: :cascade do |t|
    t.integer  "assessment_id", null: false
    t.integer  "list_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "score_list_entries", force: :cascade do |t|
    t.integer  "list_id",                             null: false
    t.integer  "entity_id",                           null: false
    t.string   "entity_type",                         null: false
    t.integer  "track",                               null: false
    t.integer  "run",                                 null: false
    t.string   "result_type",     default: "waiting", null: false
    t.integer  "assessment_type", default: 0,         null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "assessment_id",                       null: false
    t.integer  "time"
  end

  add_index "score_list_entries", ["list_id"], name: "index_score_list_entries_on_list_id"

  create_table "score_list_factories", force: :cascade do |t|
    t.string   "session_id"
    t.integer  "discipline_id",    null: false
    t.string   "name"
    t.string   "shortcut"
    t.integer  "track_count"
    t.string   "type"
    t.integer  "before_result_id"
    t.integer  "before_list_id"
    t.integer  "best_count"
    t.string   "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "track"
    t.integer  "gender"
  end

  create_table "score_list_factory_assessments", force: :cascade do |t|
    t.integer  "assessment_id",   null: false
    t.integer  "list_factory_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "score_list_factory_assessments", ["assessment_id"], name: "index_score_list_factory_assessments_on_assessment_id"
  add_index "score_list_factory_assessments", ["list_factory_id"], name: "index_score_list_factory_assessments_on_list_factory_id"

  create_table "score_lists", force: :cascade do |t|
    t.string   "name",        default: "", null: false
    t.integer  "track_count", default: 2,  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "shortcut",    default: "", null: false
    t.date     "date"
  end

  create_table "score_result_list_factories", force: :cascade do |t|
    t.integer  "list_factory_id", null: false
    t.integer  "result_id",       null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "score_result_list_factories", ["list_factory_id"], name: "index_score_result_list_factories_on_list_factory_id"
  add_index "score_result_list_factories", ["result_id"], name: "index_score_result_list_factories_on_result_id"

  create_table "score_result_lists", force: :cascade do |t|
    t.integer  "list_id",    null: false
    t.integer  "result_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "score_result_lists", ["list_id"], name: "index_score_result_lists_on_list_id"
  add_index "score_result_lists", ["result_id"], name: "index_score_result_lists_on_result_id"

  create_table "score_results", force: :cascade do |t|
    t.string   "name",                   default: "",              null: false
    t.boolean  "group_assessment",       default: false,           null: false
    t.integer  "assessment_id",                                    null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "double_event_result_id"
    t.string   "type",                   default: "Score::Result", null: false
    t.integer  "group_score_count"
    t.integer  "group_run_count"
    t.date     "date"
  end

  add_index "score_results", ["assessment_id"], name: "index_score_results_on_assessment_id"
  add_index "score_results", ["double_event_result_id"], name: "index_score_results_on_double_event_result_id"

  create_table "series_assessment_results", force: :cascade do |t|
    t.integer  "assessment_id",   null: false
    t.integer  "score_result_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "series_assessment_results", ["assessment_id"], name: "index_series_assessment_results_on_assessment_id"
  add_index "series_assessment_results", ["score_result_id"], name: "index_series_assessment_results_on_score_result_id"

  create_table "series_assessments", force: :cascade do |t|
    t.integer  "round_id",                null: false
    t.string   "discipline",              null: false
    t.string   "name",       default: "", null: false
    t.string   "type",                    null: false
    t.integer  "gender",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "series_cups", force: :cascade do |t|
    t.integer  "round_id",          null: false
    t.string   "competition_place", null: false
    t.date     "competition_date",  null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "series_participations", force: :cascade do |t|
    t.integer  "assessment_id",             null: false
    t.integer  "cup_id",                    null: false
    t.string   "type",                      null: false
    t.integer  "team_id"
    t.integer  "team_number"
    t.integer  "person_id"
    t.integer  "time",                      null: false
    t.integer  "points",        default: 0, null: false
    t.integer  "rank",                      null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "series_rounds", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "year",           null: false
    t.string   "aggregate_type", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "tag_references", force: :cascade do |t|
    t.integer  "tag_id",        null: false
    t.integer  "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",           null: false
    t.string   "type",           null: false
    t.integer  "competition_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "team_relays", force: :cascade do |t|
    t.integer  "team_id",                null: false
    t.integer  "number",     default: 1, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "team_relays", ["team_id"], name: "index_team_relays_on_team_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name",                                       null: false
    t.integer  "gender",                                     null: false
    t.integer  "number",                        default: 1,  null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "shortcut",                      default: "", null: false
    t.integer  "fire_sport_statistics_team_id"
    t.integer  "lottery_number"
    t.integer  "federal_state_id"
  end

  add_index "teams", ["federal_state_id"], name: "index_teams_on_federal_state_id"
  add_index "teams", ["fire_sport_statistics_team_id"], name: "index_teams_on_fire_sport_statistics_team_id"

  create_table "user_assessment_abilities", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "assessment_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_assessment_abilities", ["assessment_id"], name: "index_user_assessment_abilities_on_assessment_id"
  add_index "user_assessment_abilities", ["user_id"], name: "index_user_assessment_abilities_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name",          null: false
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true

end
