class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :title
      t.text :description
      t.boolean :published
      t.datetime :start_date
      t.datetime :end_date
      t.integer :percent_off
      t.integer :cents_off
      t.string :code

      t.timestamps
    end
  end
end
