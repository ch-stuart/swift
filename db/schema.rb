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

ActiveRecord::Schema.define(:version => 20110226043705) do

  create_table "colors", :force => true do |t|
    t.string   "title"
    t.string   "hex"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colors_parts", :id => false, :force => true do |t|
    t.integer "part_id"
    t.integer "color_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "title"
    t.string   "email"
    t.string   "phone"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_html"
    t.string   "flickr_tag"
    t.string   "featured"
  end

  create_table "parts", :force => true do |t|
    t.string   "title"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "flickr_tag"
    t.text     "specs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "price"
    t.string   "kind"
    t.string   "short_title"
    t.string   "humane_price"
    t.string   "flickr_photo"
  end

end
