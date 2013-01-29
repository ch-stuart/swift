class RemoveFlickrIllustrationFromProducts < ActiveRecord::Migration
  def up
      remove_column :products, :flickr_illustration
  end

  def down
      add_column :products, :flickr_illustration, :string
  end
end
