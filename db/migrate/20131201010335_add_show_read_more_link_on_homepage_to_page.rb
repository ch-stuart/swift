class AddShowReadMoreLinkOnHomepageToPage < ActiveRecord::Migration
  def change
    add_column :pages, :hide_title_on_homepage, :boolean, :null => false, :default => false
    add_column :pages, :hide_read_more_link_on_homepage, :boolean, :null => false, :default => false
  end
end
