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

ActiveRecord::Schema.define(:version => 20120215223534) do

  create_table "color_themes", :force => true do |t|
    t.text     "gradient"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "external_data_sources", :force => true do |t|
    t.string   "name"
    t.string   "class_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "external_data_sources_geo_graphs", :id => false, :force => true do |t|
    t.integer "external_data_source_id"
    t.integer "geo_graph_id"
  end

  create_table "geo_graphs", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "color_measure_id"
    t.integer  "size_measure_id"
    t.integer  "max_spot_size"
    t.integer  "min_spot_size"
    t.integer  "num_legend_sizes"
    t.integer  "num_legend_colors"
    t.integer  "color_theme_id"
    t.integer  "num_zoom_levels"
    t.string   "import_data_file_name"
    t.string   "import_data_content_type"
    t.integer  "import_data_file_size"
    t.datetime "import_data_updated_at"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "measures", :force => true do |t|
    t.string   "name"
    t.string   "api_url"
    t.integer  "geo_graph_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "place_measures", :force => true do |t|
    t.float    "value"
    t.integer  "place_id"
    t.integer  "measure_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "api_abbr"
    t.integer  "geo_graph_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
