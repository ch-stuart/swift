require 'test_helper'

class PageTest < ActiveSupport::TestCase

  def setup
    @page = {
      :title => "foo bar",
      :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      :path => "foo_bar",
      :status => "Public",
      :flickr_tag => "foo_bar"
    }
  end
  
  test "should create page" do
    page = Page.new @page
    assert page.save, "should save page"
  end

  test "should not save page without title" do
    page = Page.new @page.except(:title)
    assert !page.save, "should not save page"
  end

  test "should not save page without body" do
    page = Page.new @page.except(:body)
    assert !page.save, "should not save page"
  end

  test "should not save page without path" do
    page = Page.new @page.except(:path)
    assert !page.save, "should not save page"
  end

  test "title should be unique" do
    page = Page.new @page
    page.save
    
    page2 = {
      :title => "foo bar",
      :body => "la la la",
      :path => "boo"
    }
    page2 = Page.new 
    assert !page2.save, "title has to be unique"
  end
    
  test "path should be unique" do
    page = Page.new @page
    page.save
    
    page2 = {
      :title => "foo bar baz",
      :body => "la la la",
      :path => "foo_bar"
    }
    page2 = Page.new 
    assert !page2.save, "path should be unique"
  end
    
end
