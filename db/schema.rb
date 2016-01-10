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

ActiveRecord::Schema.define(version: 20160109151751) do

  create_table "archived_old_lend_outs", force: :cascade do |t|
    t.string   "deposit"
    t.string   "imt"
    t.string   "lender"
    t.string   "receiver"
    t.datetime "lendingTime"
    t.datetime "receivingTime"
    t.integer  "weigth"
    t.string   "old_folder_instances"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "archived_old_lend_outs_old_folder_instances", id: false, force: :cascade do |t|
    t.integer "archived_old_lend_out_id", null: false
    t.integer "old_folder_instance_id",   null: false
  end

  create_table "old_exams", force: :cascade do |t|
    t.string   "title"
    t.string   "examiners"
    t.date     "date"
    t.integer  "old_folder_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "old_exams", ["old_folder_id"], name: "index_old_exams_on_old_folder_id"

  create_table "old_folder_instances", force: :cascade do |t|
    t.integer  "number"
    t.integer  "old_folder_id"
    t.string   "barcodeId"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "old_lend_out_id"
  end

  add_index "old_folder_instances", ["old_folder_id"], name: "index_old_folder_instances_on_old_folder_id"
  add_index "old_folder_instances", ["old_lend_out_id"], name: "index_old_folder_instances_on_old_lend_out_id"

  create_table "old_folders", force: :cascade do |t|
    t.string   "title"
    t.string   "contentType"
    t.string   "area"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "color",       default: 0, null: false
  end

  create_table "old_lend_outs", force: :cascade do |t|
    t.string   "deposit"
    t.string   "imt"
    t.string   "lender"
    t.datetime "lendingTime"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "weigth"
    t.string   "receivingTime"
    t.string   "receiver"
  end

end
