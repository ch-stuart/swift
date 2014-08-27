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

ActiveRecord::Schema.define(:version => 20140827041549) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colors", :force => true do |t|
    t.string   "title"
    t.string   "hex"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wholesale_price"
  end

  create_table "colors_parts", :id => false, :force => true do |t|
    t.integer  "part_id"
    t.integer  "color_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "title"
    t.string   "email"
    t.string   "phone"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "delivery_time"
    t.text     "front_door_sign"
    t.boolean  "close_shop",         :default => false,                                                    :null => false
    t.text     "close_shop_message", :default => "The shop is currently closed. Please check back later."
  end

  create_table "contacts", :force => true do |t|
    t.text     "email"
    t.boolean  "archived",   :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "gift_certificates", :force => true do |t|
    t.integer  "sale_id"
    t.integer  "amount"
    t.string   "guid"
    t.integer  "remaining_amount"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "homes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "path"
    t.string   "status"
    t.string   "video_html"
    t.string   "flickr_tag"
    t.string   "featured"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
    t.boolean  "show_video_on_homepage",          :default => false, :null => false
    t.boolean  "show_photo_on_homepage",          :default => false, :null => false
    t.string   "flickr_photo"
    t.boolean  "hide_title_on_homepage",          :default => false, :null => false
    t.boolean  "hide_read_more_link_on_homepage", :default => false, :null => false
    t.boolean  "include_in_about_us_navigation",  :default => false, :null => false
  end

  create_table "parts", :force => true do |t|
    t.string   "title"
    t.string   "price"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wholesale_price"
  end

  create_table "pre_approved_dealers", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "flickr_tag"
    t.text     "specs"
    t.string   "status"
    t.string   "price"
    t.string   "kind"
    t.string   "short_title"
    t.string   "humane_price"
    t.string   "flickr_photo"
    t.string   "question"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "not_for_sale",           :default => false,                                                              :null => false
    t.text     "not_for_sale_message",   :default => "This product is currently not for sale. Please check back later."
    t.integer  "category_id"
    t.boolean  "featured_on_homepage",   :default => false,                                                              :null => false
    t.text     "flickr_set"
    t.text     "short_description"
    t.string   "wholesale_humane_price"
    t.string   "wholesale_price"
    t.integer  "width"
    t.integer  "height"
    t.integer  "length"
    t.float    "weight"
    t.string   "package_type",           :default => "CUSTOM"
  end

  create_table "sales", :force => true do |t|
    t.text     "email"
    t.string   "guid"
    t.text     "description"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "amount"
    t.string   "weight"
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.integer  "shipping_charge"
    t.string   "shipping_service"
    t.string   "shipping_provider"
    t.string   "stripe_id"
    t.string   "tax_rate"
    t.string   "tax_amount"
    t.string   "total"
    t.string   "status"
    t.string   "phone_no"
    t.string   "contact"
    t.string   "company"
    t.string   "gift_certificate_guid"
    t.integer  "gift_cert_remain"
    t.integer  "gift_cert_applied"
    t.integer  "total_with_gift_cert"
    t.boolean  "pickup",                :default => false, :null => false
    t.boolean  "commercial",            :default => false, :null => false
  end

  create_table "shipments", :force => true do |t|
    t.string   "postmaster_id"
    t.string   "tracking_number"
    t.string   "carrier"
    t.string   "weight"
    t.string   "width"
    t.string   "height"
    t.string   "length"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "sale_id"
    t.integer  "cost"
    t.string   "envelope"
  end

  create_table "sizes", :force => true do |t|
    t.string   "title"
    t.string   "price"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wholesale_price"
  end

  create_table "testimonials", :force => true do |t|
    t.text     "body"
    t.string   "author"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0,     :null => false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.boolean  "wholesale",              :default => false
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "phone_no"
    t.text     "company"
    t.text     "company_url"
    t.string   "contact"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
