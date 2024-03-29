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

ActiveRecord::Schema.define(version: 20140820141207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: true do |t|
    t.integer  "weis_id",                limit: 8
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "password"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.integer  "balance"
    t.boolean  "gold_member"
    t.integer  "program_id"
    t.integer  "buyer_id"
    t.date     "rewards",                          default: [],              array: true
    t.datetime "deactivated_at"
    t.integer  "rewards_to_be_uploaded"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "customers", ["deactivated_at"], name: "index_customers_on_deactivated_at", using: :btree
  add_index "customers", ["email_address"], name: "index_customers_on_email_address", unique: true, using: :btree

end
