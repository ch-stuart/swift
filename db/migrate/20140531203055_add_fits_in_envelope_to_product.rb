class AddFitsInEnvelopeToProduct < ActiveRecord::Migration
  def change
    add_column :products, :package_type, :string, :default => "CUSTOM"
  end
end
