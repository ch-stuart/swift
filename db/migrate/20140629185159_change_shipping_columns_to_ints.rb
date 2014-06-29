class ChangeShippingColumnsToInts < ActiveRecord::Migration
  def up
    # http://stackoverflow.com/a/19397902/203013
    change_column :shipments, :cost, 'integer USING CAST(cost AS integer)'
    change_column :sales, :shipping_charge, 'integer USING CAST(shipping_charge AS integer)'
  end

  # varchar? need to know what PG uses for rails "string"
  # def down
  #   # http://stackoverflow.com/a/19397902/203013
  #   change_column :shipments, :cost, 'integer USING CAST(cost AS integer)'
  #   change_column :sales, :shipping_charge, 'integer USING CAST(shipping_charge AS integer)'
  # end
end
