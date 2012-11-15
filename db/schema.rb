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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121113150646) do

  create_table "tag_app_relations", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "webapp_id"
    t.integer  "coeff",      :default => 0
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tag_app_relations", ["tag_id", "webapp_id"], :name => "index_tag_app_relations_on_tag_id_and_webapp_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "surname"
    t.string   "firstname"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "webapps", :force => true do |t|
    t.string   "title"
    t.string   "caption"
    t.text     "description"
    t.boolean  "validate"
    t.string   "url"
    t.string   "image"
    t.float    "average_rate"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "nb_click_preview",   :default => 0
    t.integer  "nb_click_detail",    :default => 0
    t.integer  "nb_click_url",       :default => 0
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "promoted"
  end

end
