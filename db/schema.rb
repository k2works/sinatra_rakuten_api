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

ActiveRecord::Schema.define(version: 20131219072839) do

  create_table "genre_rankings", force: true do |t|
    t.integer  "rank"
    t.string   "name"
    t.integer  "genre_id"
    t.string   "genre_name"
    t.string   "title"
    t.datetime "last_build_date"
    t.string   "item_code"
    t.decimal  "item_price"
    t.integer  "review_count"
    t.decimal  "review_average"
    t.string   "shop_code"
    t.string   "shop_name"
  end

  create_table "genre_searches", force: true do |t|
    t.integer "genre_id"
    t.string  "name"
  end

  create_table "item_rankings", force: true do |t|
    t.string  "name"
    t.decimal "price"
  end

  create_table "item_searches", force: true do |t|
    t.string  "name"
    t.decimal "price"
  end

end
