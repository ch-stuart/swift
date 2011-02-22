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

Page.create(
    :title => "Our Story",
    :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    :path => "our_story",
    :video_html => '<iframe title="YouTube video player" width="480" height="390" src="http://www.youtube.com/embed/nmSfXqeHdbU" frameborder="0" allowfullscreen></iframe>',
    :status => "Public",
    :featured => "Featured"
)

Product.create(
    :title => "Test Product",
    :description => "Test Product Description",
    :flickr_tag => "bouncy_lions",
    :specs => "Test Product Specs",
    :status => "Public",
    :price => "299.99",
    :kind => "Product"
)

Product.create(
    :title => "Test Accessory",
    :description => "Test Accessory Description",
    :flickr_tag => "jittery_goats",
    :specs => "Test Accessory Specs",
    :status => "Public",
    :price => "99.99",
    :kind => "Accessory"
)

Color.create(
    :title => "Hot Pink",
    :hex => "#de41a4"
)

Color.create(
    :title => "Black",
    :hex => "#000"
)

Color.create(
    :title => "White",
    :hex => "#fff"
)

Color.create(
    :title => "Gray",
    :hex => "#aaa"
)