class AddVideoToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :video_html, :string
  end

  def self.down
    remove_column :pages, :video_html
  end
end
