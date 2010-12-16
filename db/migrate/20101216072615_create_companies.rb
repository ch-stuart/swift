class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :title
      t.string :email
      t.string :phone
      t.text :address

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
