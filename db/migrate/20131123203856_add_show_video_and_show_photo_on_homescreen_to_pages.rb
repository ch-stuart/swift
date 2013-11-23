class AddShowVideoAndShowPhotoOnHomescreenToPages < ActiveRecord::Migration
  def change
    add_column :pages, :show_video_on_homepage, :boolean, :null => false, :default => false
    add_column :pages, :show_photos_on_homepage, :boolean, :null => false, :default => false
  end
end
