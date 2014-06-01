class AddPhoneNoToSales < ActiveRecord::Migration
  def change
    add_column :sales, :phone_no, :string
  end
end
