class AddEnvelopeToShipment < ActiveRecord::Migration
  def change
    add_column :shipments, :envelope, :string
  end
end
