# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Company.create(
    :title => "Swift Industries",
    :email => "swiftindustry@yahoo.com",
    :phone => "(206) 325.0054",
    :address => "1422 20th AVE Seattle, WA 98122"
)

Color.create(
    :title => "Hot Pink",
    :hex => "de41a4"
)

Page.create(
    :title => "Test Page",
    :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    :path => "test",
    :status => "Public"
)

Product.create(
    :title => "Test Product",
    :description => "Test Product Description",
    :flickr_tag => "bouncy_lions",
    :specs => "Test Product Specs",
    :status => "Public",
    :price => "299.99"
)