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

ActiveRecord::Schema.define(version: 20150429201357) do

  create_table "assessment_requests", force: :cascade do |t|
    t.integer  "assessment_id",               null: false
    t.integer  "entity_id",                   null: false
    t.string   "entity_type",                 null: false
    t.integer  "assessment_type", default: 0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "assessment_requests", ["assessment_id"], name: "index_assessment_requests_on_assessment_id"
  add_index "assessment_requests", ["entity_type", "entity_id"], name: "index_assessment_requests_on_entity_type_and_entity_id"

  create_table "assessments", force: :cascade do |t|
    t.string   "name",          default: "", null: false
    t.integer  "discipline_id",              null: false
    t.integer  "gender"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "assessments", ["discipline_id"], name: "index_assessments_on_discipline_id"

  create_table "competitions", force: :cascade do |t|
    t.string   "name",       default: "",    null: false
    t.date     "date",                       null: false
    t.boolean  "configured", default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "disciplines", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "type",                    null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "fire_sport_statistics_people", force: :cascade do |t|
    t.string   "last_name",   null: false
    t.string   "first_name",  null: false
    t.integer  "gender",      null: false
    t.string   "external_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "fire_sport_statistics_people", ["external_id"], name: "index_fire_sport_statistics_people_on_external_id"

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
    t.string   "name",        null: false
    t.string   "short",       null: false
    t.string   "external_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "fire_sport_statistics_teams", ["external_id"], name: "index_fire_sport_statistics_teams_on_external_id"

  create_table "people", force: :cascade do |t|
    t.string   "last_name",  null: false
    t.string   "first_name", null: false
    t.integer  "gender",     null: false
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "people", ["team_id"], name: "index_people_on_team_id"

  create_table "score_list_entries", force: :cascade do |t|
    t.integer  "list_id",                         null: false
    t.integer  "entity_id",                       null: false
    t.string   "entity_type",                     null: false
    t.integer  "track",                           null: false
    t.integer  "run",                             null: false
    t.string   "result_type", default: "waiting", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "score_list_entries", ["list_id"], name: "index_score_list_entries_on_list_id"

  create_table "score_lists", force: :cascade do |t|
    t.string   "name",             default: "", null: false
    t.integer  "track_count",      default: 2,  null: false
    t.integer  "assessment_id",                 null: false
    t.integer  "result_time_type"
    t.integer  "result_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "score_lists", ["assessment_id"], name: "index_score_lists_on_assessment_id"
  add_index "score_lists", ["result_id"], name: "index_score_lists_on_result_id"

  create_table "score_results", force: :cascade do |t|
    t.string   "name",             default: "",    null: false
    t.boolean  "group_assessment", default: false, null: false
    t.integer  "assessment_id",                    null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "score_results", ["assessment_id"], name: "index_score_results_on_assessment_id"

  create_table "score_stopwatch_times", force: :cascade do |t|
    t.integer  "list_entry_id", null: false
    t.integer  "time",          null: false
    t.string   "type",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "score_stopwatch_times", ["list_entry_id"], name: "index_score_stopwatch_times_on_list_entry_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "gender",                 null: false
    t.integer  "number",     default: 1, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
