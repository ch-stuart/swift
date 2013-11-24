class RenameShowFlickrPhonesOnHomepage < ActiveRecord::Migration
  def change
    rename_column :pages, :show_photos_on_homepage, :show_photo_on_homepage
  end
end
