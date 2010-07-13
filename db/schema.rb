# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100713120713) do

  create_table "business_relations", :force => true do |t|
    t.integer  "member_id"
    t.integer  "business_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "city"
    t.string   "status",                                            :default => "unverified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "contact_website"
    t.string   "contact_address"
    t.string   "map"
    t.text     "description"
    t.datetime "opening_time"
    t.datetime "closing_time"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.decimal  "lng",                :precision => 10, :scale => 7
    t.decimal  "lat",                :precision => 10, :scale => 7
    t.integer  "is_premium",                                        :default => 0
    t.boolean  "delta",                                             :default => false,        :null => false
  end

  create_table "businesses_categories", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "category_id"
  end

  add_index "businesses_categories", ["business_id"], :name => "index_businesses_categories_on_business_id"
  add_index "businesses_categories", ["category_id"], :name => "index_businesses_categories_on_category_id"

  create_table "businesses_sub_categories", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "sub_category_id"
  end

  add_index "businesses_sub_categories", ["business_id"], :name => "index_businesses_sub_categories_on_business_id"
  add_index "businesses_sub_categories", ["sub_category_id"], :name => "index_businesses_sub_categories_on_sub_category_id"

  create_table "categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "categories_sub_categories", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "sub_category_id"
  end

  add_index "categories_sub_categories", ["category_id"], :name => "index_categories_sub_categories_on_category_id"
  add_index "categories_sub_categories", ["sub_category_id"], :name => "index_categories_sub_categories_on_sub_category_id"

  create_table "cities", :force => true do |t|
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.decimal  "lng",        :precision => 10, :scale => 7
    t.decimal  "lat",        :precision => 10, :scale => 7
  end

  create_table "members", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "salt"
    t.string   "hashed_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
    t.string   "address"
    t.string   "remember_me_token"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "remember_me_time"
    t.boolean  "is_admin",           :default => false
  end

  create_table "notifications", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "business_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "address1"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "zip"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sub_categories", :force => true do |t|
    t.string   "sub_category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
