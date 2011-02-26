class AddFeaturedPhotoToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :flickr_photo, :string
  end

  def self.down
    remove_column :products, :flickr_photo
  end
end
