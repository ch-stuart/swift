class AddRelatedProductsToProduct < ActiveRecord::Migration
  def change
      add_column :products, :related_products, :text
  end
end
