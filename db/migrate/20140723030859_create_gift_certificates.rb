class CreateGiftCertificates < ActiveRecord::Migration
  def change
    create_table :gift_certificates do |t|
      t.integer :sale_id
      t.integer :amount
      t.string :guid
      t.integer :remaining_amount

      t.timestamps
    end
  end
end
