class AddFeaturedOnHomepageToProducts < ActiveRecord::Migration
  def change
      add_column :products, :featured_on_homepage, :boolean, :null => false, :default => false
  end
end
