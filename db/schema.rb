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

ActiveRecord::Schema.define(:version => 20120322142255) do

  create_table "color_themes", :force => true do |t|
    t.text     "gradient"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "data_maps", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "color_field_id"
    t.integer  "size_field_id"
    t.integer  "max_spot_size"
    t.integer  "min_spot_size"
    t.integer  "num_legend_sizes"
    t.integer  "num_legend_colors"
    t.integer  "color_theme_id"
    t.integer  "num_zoom_levels"
    t.integer  "default_zoom_level"
    t.float    "default_latitude"
    t.float    "default_longitude"
    t.string   "import_data_file_name"
    t.string   "import_data_content_type"
    t.integer  "import_data_file_size"
    t.datetime "import_data_updated_at"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "data_maps_external_data_sources", :id => false, :force => true do |t|
    t.integer "external_data_source_id"
    t.integer "data_map_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "external_data_sources", :force => true do |t|
    t.string   "name"
    t.string   "class_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.string   "api_url"
    t.integer  "data_map_id"
    t.integer  "external_data_source_id"
    t.string   "datatype",                :default => "numeric"
    t.boolean  "log_scale",               :default => false
    t.boolean  "reverse_color_theme",     :default => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "fields", ["datatype"], :name => "index_fields_on_datatype"

  create_table "place_fields", :force => true do |t|
    t.float    "value"
    t.integer  "place_id"
    t.integer  "field_id"
    t.text     "metadata"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "place_fields", ["field_id"], :name => "index_place_fields_on_field_id"
  add_index "place_fields", ["place_id"], :name => "index_place_fields_on_place_id"

  create_table "places", :force => true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "api_abbr"
    t.integer  "data_map_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "places", ["data_map_id"], :name => "index_places_on_data_map_id"

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
