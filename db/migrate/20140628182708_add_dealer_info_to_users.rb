class AddDealerInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :line1, :string
    add_column :users, :line2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip_code, :string
    add_column :users, :country, :string
    add_column :users, :phone_no, :string
    add_column :users, :company, :text
    add_column :users, :company_url, :text
    add_column :users, :contact, :string
  end
end
