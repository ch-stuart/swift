class CreateTestimonials < ActiveRecord::Migration
  def self.up
    create_table :testimonials do |t|
      t.text :body
      t.string :author
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :testimonials
  end
end
