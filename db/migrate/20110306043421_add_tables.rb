class AddTables < ActiveRecord::Migration
    def self.up
        create_table "colors", :force => true do |t|
            t.string   "title"
            t.string   "hex"
            t.string   "price"
            t.timestamps
        end

        create_table "colors_parts", :id => false, :force => true do |t|
            t.integer "part_id"
            t.integer "color_id"
            t.timestamps
        end

        create_table "companies", :force => true do |t|
            t.string   "title"
            t.string   "email"
            t.string   "phone"
            t.text     "address"
            t.timestamps
        end

        create_table "homes", :force => true do |t|
            t.timestamps
        end

        create_table "pages", :force => true do |t|
            t.string   "title"
            t.text     "body"
            t.string   "path"
            t.string   "status"
            t.string   "video_html"
            t.string   "flickr_tag"
            t.string   "featured"
            t.timestamps
        end

        create_table "parts", :force => true do |t|
            t.string   "title"
            t.string   "price"
            t.integer  "product_id"
            t.timestamps
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
            t.string   "flickr_illustration"
            t.string   "question"
            t.string   "answer"
            t.timestamps
        end

        create_table "sizes", :force => true do |t|
            t.string   "title"
            t.string   "price"
            t.integer  "product_id"
            t.timestamps
        end

        create_table "testimonials", :force => true do |t|
            t.text     "body"
            t.string   "author"
            t.integer  "product_id"
            t.timestamps
        end
    end

    def self.down
        drop_table :colors
        drop_table :colors_parts
        drop_table :companies
        drop_table :homes
        drop_table :pages
        drop_table :parts
        drop_table :products
        drop_table :sizes
        drop_table :testimonials
    end
end



