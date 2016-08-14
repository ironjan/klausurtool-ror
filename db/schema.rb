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

ActiveRecord::Schema.define(version: 20160814121214) do

  create_table "archived_old_lend_outs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "deposit"
    t.string   "imt"
    t.string   "lender"
    t.string   "receiver"
    t.datetime "lendingTime"
    t.datetime "receivingTime"
    t.integer  "weigth"
    t.text     "old_folder_instances", limit: 4294967295
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "archived_old_lend_outs_old_folder_instances", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "archived_old_lend_out_id", null: false
    t.integer "old_folder_instance_id",   null: false
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "folder_instance_archive_copies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "folder_title"
    t.integer  "barcode_id"
    t.integer  "archived_old_lend_out_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "old_exams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "title"
    t.string   "examiners"
    t.date     "date"
    t.integer  "old_folder_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "unarchived",    default: true
    t.index ["old_folder_id"], name: "index_old_exams_on_old_folder_id", using: :btree
  end

  create_table "old_folder_instances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "number"
    t.integer  "old_folder_id"
    t.string   "barcodeId"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "old_lend_out_id"
    t.index ["old_folder_id"], name: "index_old_folder_instances_on_old_folder_id", using: :btree
    t.index ["old_lend_out_id"], name: "index_old_folder_instances_on_old_lend_out_id", using: :btree
  end

  create_table "old_folders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "title"
    t.string   "contentType"
    t.string   "area"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "color",       default: 0, null: false
  end

  create_table "old_lend_outs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
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
