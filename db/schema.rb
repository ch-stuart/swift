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

ActiveRecord::Schema.define(:version => 20131201010335) do

  create_table "categories", :force => true do |t|
    t.string    "title"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "colors", :force => true do |t|
    t.string    "title"
    t.string    "hex"
    t.string    "price"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "colors_parts", :id => false, :force => true do |t|
    t.integer   "part_id"
    t.integer   "color_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string    "title"
    t.string    "email"
    t.string    "phone"
    t.text      "address"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "description"
    t.text      "delivery_time"
    t.text      "front_door_sign"
    t.boolean   "close_shop",         :default => false,                                                    :null => false
    t.text      "close_shop_message", :default => "The shop is currently closed. Please check back later."
  end

  create_table "homes", :force => true do |t|
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string    "title"
    t.text      "body"
    t.string    "path"
    t.string    "status"
    t.string    "video_html"
    t.string    "flickr_tag"
    t.string    "featured"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "summary"
    t.boolean   "show_video_on_homepage",          :default => false, :null => false
    t.boolean   "show_photo_on_homepage",          :default => false, :null => false
    t.string    "flickr_photo"
    t.boolean   "hide_title_on_homepage",          :default => false, :null => false
    t.boolean   "hide_read_more_link_on_homepage", :default => false, :null => false
  end

  create_table "parts", :force => true do |t|
    t.string    "title"
    t.string    "price"
    t.integer   "product_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string    "title"
    t.text      "description"
    t.string    "flickr_tag"
    t.text      "specs"
    t.string    "status"
    t.string    "price"
    t.string    "kind"
    t.string    "short_title"
    t.string    "humane_price"
    t.string    "flickr_photo"
    t.string    "question"
    t.string    "answer"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "not_for_sale",         :default => false,                                                              :null => false
    t.text      "not_for_sale_message", :default => "This product is currently not for sale. Please check back later."
    t.integer   "category_id"
    t.boolean   "featured_on_homepage", :default => false,                                                              :null => false
    t.text      "flickr_set"
    t.text      "short_description"
  end

  create_table "sizes", :force => true do |t|
    t.string    "title"
    t.string    "price"
    t.integer   "product_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "testimonials", :force => true do |t|
    t.text      "body"
    t.string    "author"
    t.integer   "product_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

end
