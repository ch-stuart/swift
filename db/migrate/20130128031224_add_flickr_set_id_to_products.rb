class AddFlickrSetIdToProducts < ActiveRecord::Migration
  def change
      add_column :products, :flickr_set, :text
  end
end
