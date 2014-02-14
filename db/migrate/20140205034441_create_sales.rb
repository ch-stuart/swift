class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.text :email
      t.string :guid
      t.text :description

      t.timestamps
    end
  end
end
