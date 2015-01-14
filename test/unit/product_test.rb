require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  def setup
    @product = {
      :title => "Big Big Bag",
      :short_title => "BB Bag",
      :description => "You've never seen a bag this big",
      :short_description => "You've never seen a bag this big",
      :flickr_tag => "flickr_tag-is-nice",
      :specs => "1 foot x 1 foot x 1 foot",
      :status => "Public",
      :price => "25.00",
      :wholesale_price => "20.00",
      :kind => "Product",
      :humane_price => "25 bucks!",
      :wholesale_humane_price => "20 bucks!",
      :flickr_photo => "1234567890",
      :flickr_set => "09876543210987653",
      :question => "What?",
      :answer => "42",
      :not_for_sale => false,
      :not_for_sale_message => "We are all out. :(",
      :featured_on_homepage => false,
      :category_id => 1
    }
  end

  test "should save" do
    product = Product.new @product
    assert product.save!, "Should save"
  end

  test "should note save with bad kind" do
    @product[:kind] = "bogus!"
    product = Product.new @product
    assert !product.save, "Should not save"
  end

  test "should note save without category" do
    product = Product.new @product.except(:category_id)
    assert !product.save, "should not save without category_id"
  end

  test "should note save with bad status" do
    @product[:status] = "bogus!"
    product = Product.new @product
    assert !product.save, "Should not save"
  end

  test "should not save with bad tag format" do
    @product[:flickr_tag] = "lala!"
    product = Product.new @product
    assert !product.save, "Should not save"
  end

  test "should not save with bad photo format (12 digits not legal)" do
    @product[:flickr_photo] = "123456789100"
    product = Product.new @product
    assert !product.save, "Should not save"
  end

  test "should save with 11 digits (used to be only 10 digits, flickr added enough photos)" do
    @product[:flickr_photo] = "12345678910"
    product = Product.new @product
    assert product.save, "Should save"
  end

  test "should not save without title" do
    product = Product.new @product.except(:title)
    assert !product.save, "should not save without title"
  end

  test "should not save without price" do
    product = Product.new @product.except(:price)
    assert !product.save, "should not save without price"
  end

  test "should not save without short title" do
    product = Product.new @product.except(:short_title)
    assert !product.save, "should not save without short title"
  end

  test "short title should be unique" do
    product = Product.new @product
    product.save

    product2 = Product.new @product
    product2[:title] = "unique"
    product2[:flickr_tag] = "unique"
    assert !product2.save, "not unique"
  end

  test "title should be unique" do
    product = Product.new @product
    product.save

    product2 = Product.new @product
    product2[:short_title] = "unique"
    product2[:flickr_tag] = "unique"
    assert !product2.save, "not unique"
  end

  test "flickr_tag doesn't have to be be unique" do
    product = Product.new @product
    product.save

    product2 = Product.new @product
    product2[:title] = "unique"
    product2[:short_title] = "unique"
    assert product2.save, "not unique"
  end

  test "should create product with part" do
    part = Part.new title: "foo"
    part2 = Part.new title: "goo"

    @product[:parts] = [part, part2]
    product = Product.new @product
    assert product.save, "should save"
    assert product.parts.size == 2
  end

end
