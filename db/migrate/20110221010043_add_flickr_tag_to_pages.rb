class AddFlickrTagToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :flickr_tag, :string
  end

  def self.down
    remove_column :pages, :flickr_tag
  end
end
