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

ActiveRecord::Schema.define(version: 1) do

  create_table "customers", force: :cascade do |t|
    t.string "name", limit: 30, default: "", null: false
    t.string "mail", limit: 30, default: "", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", limit: 30, default: "", null: false
  end

  create_table "history", force: :cascade do |t|
    t.integer  "issue_id",        limit: 4,     default: 0, null: false
    t.text     "notes",           limit: 65535
    t.datetime "created_on",                                null: false
    t.integer  "historized_id",   limit: 4
    t.string   "historized_type", limit: 255
  end

  add_index "history", ["historized_id", "historized_type"], name: "history_historized_id", using: :btree
  add_index "history", ["historized_id"], name: "historized_id", using: :btree

  create_table "issue_statuses", force: :cascade do |t|
    t.string  "name",       limit: 30, default: "",    null: false
    t.boolean "is_closed",  limit: 1,  default: false, null: false
    t.boolean "is_default", limit: 1,  default: false, null: false
  end

  create_table "issues", force: :cascade do |t|
    t.string   "public_id",      limit: 17,                 null: false
    t.string   "subject",        limit: 255,   default: "", null: false
    t.text     "description",    limit: 65535
    t.integer  "department_id",  limit: 4,     default: 1,  null: false
    t.integer  "status_id",      limit: 4,     default: 0,  null: false
    t.integer  "assigned_to_id", limit: 4
    t.integer  "author_id",      limit: 4,     default: 0,  null: false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "issues", ["public_id"], name: "issues_public_id", using: :btree

  create_table "staff", force: :cascade do |t|
    t.string  "login",           limit: 30, default: "",    null: false
    t.string  "hashed_password", limit: 40, default: "",    null: false
    t.string  "name",            limit: 30, default: "",    null: false
    t.string  "mail",            limit: 30, default: "",    null: false
    t.integer "department_id",   limit: 4,  default: 1,     null: false
    t.boolean "admin",           limit: 1,  default: false, null: false
  end

end
