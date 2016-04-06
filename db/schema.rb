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

ActiveRecord::Schema.define(version: 20160329195830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendship_batch_changes", force: :cascade do |t|
    t.integer "user_id"
    t.text    "twitter_users_ids"
    t.string  "friendship_status"
    t.string  "status"
    t.text    "processed_twitter_users_ids"
    t.text    "unprocessed_twitter_users_ids"
  end

  create_table "twitter_user_relations", force: :cascade do |t|
    t.integer "from_id"
    t.integer "to_id"
  end

  add_index "twitter_user_relations", ["from_id"], name: "index_twitter_user_relations_on_from_id", using: :btree
  add_index "twitter_user_relations", ["to_id"], name: "index_twitter_user_relations_on_to_id", using: :btree

  create_table "twitter_users", force: :cascade do |t|
    t.integer  "twitter_id",            limit: 8
    t.string   "name"
    t.string   "screen_name"
    t.integer  "friends_count"
    t.integer  "followers_count"
    t.integer  "statuses_count"
    t.string   "profile_image_url"
    t.datetime "friends_verified_on"
    t.datetime "followers_verified_on"
    t.datetime "verified_on"
  end

  add_index "twitter_users", ["twitter_id"], name: "index_twitter_users_on_twitter_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "name"
    t.string  "screen_name"
    t.integer "twitter_id",  limit: 8
    t.string  "token"
    t.string  "secret"
  end

end
