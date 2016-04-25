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

ActiveRecord::Schema.define(version: 20160425120127) do

  create_table "archived_old_lend_outs", force: :cascade do |t|
    t.string   "deposit",              limit: 255
    t.string   "imt",                  limit: 255
    t.string   "lender",               limit: 255
    t.string   "receiver",             limit: 255
    t.datetime "lendingTime"
    t.datetime "receivingTime"
    t.integer  "weigth",               limit: 4
    t.string   "old_folder_instances", limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "archived_old_lend_outs_old_folder_instances", id: false, force: :cascade do |t|
    t.integer "archived_old_lend_out_id", limit: 4, null: false
    t.integer "old_folder_instance_id",   limit: 4, null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "old_exams", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.string   "examiners",     limit: 255
    t.date     "date"
    t.integer  "old_folder_id", limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "visible"
    t.boolean  "unarchived",                default: true
  end

  add_index "old_exams", ["old_folder_id"], name: "index_old_exams_on_old_folder_id", using: :btree

  create_table "old_folder_instances", force: :cascade do |t|
    t.integer  "number",          limit: 4
    t.integer  "old_folder_id",   limit: 4
    t.string   "barcodeId",       limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "old_lend_out_id", limit: 4
  end

  add_index "old_folder_instances", ["old_folder_id"], name: "index_old_folder_instances_on_old_folder_id", using: :btree
  add_index "old_folder_instances", ["old_lend_out_id"], name: "index_old_folder_instances_on_old_lend_out_id", using: :btree

  create_table "old_folders", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "contentType", limit: 255
    t.string   "area",        limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "color",       limit: 4,   default: 0, null: false
  end

  create_table "old_lend_outs", force: :cascade do |t|
    t.string   "deposit",       limit: 255
    t.string   "imt",           limit: 255
    t.string   "lender",        limit: 255
    t.string   "receiver",      limit: 255
    t.datetime "lendingTime"
    t.datetime "receivingTime"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "weigth",        limit: 4
  end

  add_foreign_key "old_exams", "old_folders"
  add_foreign_key "old_folder_instances", "old_folders"
  add_foreign_key "old_folder_instances", "old_lend_outs"
end
