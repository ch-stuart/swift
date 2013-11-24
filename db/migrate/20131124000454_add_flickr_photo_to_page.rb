class AddFlickrPhotoToPage < ActiveRecord::Migration
  def change
    add_column :pages, :flickr_photo, :string
  end
end
