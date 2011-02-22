class AddFeaturedToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :featured, :string
  end

  def self.down
    remove_column :pages, :featured
  end
end
