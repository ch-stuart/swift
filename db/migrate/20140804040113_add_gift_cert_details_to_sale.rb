class AddGiftCertDetailsToSale < ActiveRecord::Migration
  def change
    add_column :sales, :gift_certificate_guid, :string
    add_column :sales, :gift_cert_remain, :integer
    add_column :sales, :gift_cert_applied, :integer
    add_column :sales, :total_with_gift_cert, :integer
  end
end
