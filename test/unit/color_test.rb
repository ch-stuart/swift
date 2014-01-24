require 'test_helper'

class ColorTest < ActiveSupport::TestCase

    def setup
        @color = {
            :title => "Red",
            :hex => "#ffff00",
            :price => "12.00"
        }
    end

    test "@color should save" do
        color = Color.new @color
        assert color.save, "should save!"
    end

    test "title is required" do
        color = Color.new @color.except(:title)
        assert !color.save, "Title is required"
    end

    test "hex is required" do
        color = Color.new @color.except(:hex)
        assert !color.save, "Hex is required"
    end

    test "hex must be correct format" do
        @color[:hex] = "ffo"
        color = Color.new @color
        assert !color.save, "Hex must be correct format"
    end

    test "price must be correct format" do
        @color[:price] = "ffo"
        color = Color.new @color
        assert !color.save, "Price must be correct format"
    end

    test "title must be unique" do
        color = Color.new @color
        color.save

        @color[:title] = "Red"
        @color[:hex] = "#ffff01"
        color2 = Color.new @color
        assert !color2.save, "title must be unique"
    end

    test "hex must be unique" do
        color = Color.new @color
        color.save

        @color[:title] = "Violet"
        @color[:hex] = "#ffff00"
        color2 = Color.new @color
        assert !color2.save, "hex must be unique"
    end

end
