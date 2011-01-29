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