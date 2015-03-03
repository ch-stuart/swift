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

ActiveRecord::Schema.define(version: 20150303043003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colors", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.string   "hex",             limit: 255
    t.string   "price",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wholesale_price", limit: 255
  end

  create_table "colors_parts", id: false, force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "color_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "email",              limit: 255
    t.string   "phone",              limit: 255
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "delivery_time"
    t.text     "front_door_sign"
    t.boolean  "close_shop",                     default: false,                                                    null: false
    t.text     "close_shop_message",             default: "The shop is currently closed. Please check back later."
  end

  create_table "contacts", force: :cascade do |t|
    t.text     "email"
    t.boolean  "archived",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description"
    t.boolean  "published"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "percent_off"
    t.integer  "cents_off"
    t.string   "code",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "gift_certificates", force: :cascade do |t|
    t.integer  "sale_id"
    t.integer  "amount"
    t.string   "guid",             limit: 255
    t.integer  "remaining_amount"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "homes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",                           limit: 255
    t.text     "body"
    t.string   "path",                            limit: 255
    t.string   "status",                          limit: 255
    t.string   "video_html",                      limit: 255
    t.string   "flickr_tag",                      limit: 255
    t.string   "featured",                        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "summary"
    t.boolean  "show_video_on_homepage",                      default: false, null: false
    t.boolean  "show_photo_on_homepage",                      default: false, null: false
    t.string   "flickr_photo",                    limit: 255
    t.boolean  "hide_title_on_homepage",                      default: false, null: false
    t.boolean  "hide_read_more_link_on_homepage",             default: false, null: false
    t.boolean  "include_in_about_us_navigation",              default: false, null: false
  end

  create_table "parts", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.string   "price",           limit: 255
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wholesale_price", limit: 255
  end

  create_table "pre_approved_dealers", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title",                                   limit: 255
    t.text     "description"
    t.string   "flickr_tag",                              limit: 255
    t.text     "specs"
    t.string   "status",                                  limit: 255
    t.string   "price",                                   limit: 255
    t.string   "kind",                                    limit: 255
    t.string   "short_title",                             limit: 255
    t.string   "humane_price",                            limit: 255
    t.string   "flickr_photo",                            limit: 255
    t.string   "question",                                limit: 255
    t.string   "answer",                                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "not_for_sale",                                        default: false,                                                              null: false
    t.text     "not_for_sale_message",                                default: "This product is currently not for sale. Please check back later."
    t.integer  "category_id"
    t.boolean  "featured_on_homepage",                                default: false,                                                              null: false
    t.text     "flickr_set"
    t.text     "short_description"
    t.string   "wholesale_humane_price",                  limit: 255
    t.string   "wholesale_price",                         limit: 255
    t.integer  "width"
    t.integer  "height"
    t.integer  "length"
    t.float    "weight"
    t.string   "package_type",                            limit: 255, default: "CUSTOM"
    t.text     "related_products"
    t.integer  "domestic_flat_rate_shipping_charge"
    t.integer  "international_flat_rate_shipping_charge"
    t.integer  "inventory_count"
  end

  create_table "sales", force: :cascade do |t|
    t.text     "email"
    t.string   "guid",                          limit: 255
    t.text     "description"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "amount",                        limit: 255
    t.string   "weight",                        limit: 255
    t.string   "line1",                         limit: 255
    t.string   "line2",                         limit: 255
    t.string   "city",                          limit: 255
    t.string   "state",                         limit: 255
    t.string   "zip_code",                      limit: 255
    t.string   "country",                       limit: 255
    t.integer  "shipping_charge"
    t.string   "shipping_service",              limit: 255
    t.string   "shipping_provider",             limit: 255
    t.string   "stripe_id",                     limit: 255
    t.string   "tax_rate",                      limit: 255
    t.string   "tax_amount",                    limit: 255
    t.string   "total",                         limit: 255
    t.string   "status",                        limit: 255
    t.string   "phone_no",                      limit: 255
    t.string   "contact",                       limit: 255
    t.string   "company",                       limit: 255
    t.string   "gift_certificate_guid",         limit: 255
    t.integer  "gift_cert_remain"
    t.integer  "gift_cert_applied"
    t.integer  "total_with_gift_cert"
    t.boolean  "pickup",                                    default: false, null: false
    t.boolean  "commercial",                                default: false, null: false
    t.text     "shipping_contact"
    t.boolean  "shipping_service_is_flat_rate"
    t.string   "coupon_code",                   limit: 255
    t.integer  "saved_with_coupon"
  end

  create_table "shipments", force: :cascade do |t|
    t.string   "postmaster_id",   limit: 255
    t.string   "tracking_number", limit: 255
    t.string   "carrier",         limit: 255
    t.string   "weight",          limit: 255
    t.string   "width",           limit: 255
    t.string   "height",          limit: 255
    t.string   "length",          limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "sale_id"
    t.integer  "cost"
    t.string   "envelope",        limit: 255
  end

  create_table "sizes", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.string   "price",           limit: 255
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wholesale_price", limit: 255
    t.integer  "inventory_count"
  end

  create_table "testimonials", force: :cascade do |t|
    t.text     "body"
    t.string   "author",     limit: 255
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                        limit: 255, default: "",    null: false
    t.string   "encrypted_password",           limit: 255, default: "",    null: false
    t.string   "reset_password_token",         limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",           limit: 255
    t.string   "last_sign_in_ip",              limit: 255
    t.integer  "failed_attempts",                          default: 0,     null: false
    t.string   "unlock_token",                 limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.boolean  "admin",                                    default: false
    t.boolean  "wholesale",                                default: false
    t.string   "line1",                        limit: 255
    t.string   "line2",                        limit: 255
    t.string   "city",                         limit: 255
    t.string   "state",                        limit: 255
    t.string   "zip_code",                     limit: 255
    t.string   "country",                      limit: 255
    t.string   "phone_no",                     limit: 255
    t.text     "company"
    t.text     "company_url"
    t.string   "contact",                      limit: 255
    t.boolean  "is_attending_campout_in_2015",             default: false, null: false
    t.boolean  "is_pending_wholesale",                     default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
