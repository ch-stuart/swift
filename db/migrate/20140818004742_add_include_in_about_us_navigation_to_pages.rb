class AddIncludeInAboutUsNavigationToPages < ActiveRecord::Migration
  def change
    add_column :pages, :include_in_about_us_navigation, :boolean, :null => false, :default => false
  end
end
