require 'test_helper'

class HomesControllerTest < ActionController::TestCase

  setup do

  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should use application layout" do
    get :index
    assert_template layout: "layouts/application"
  end

  test "should display a featured page" do
    get :index
    assert_select ".featured-page", 1
  end

  test "should display a blog entry" do
    get :index
    assert_select ".blog", 1
  end

  test "should display a hero" do
    get :index
    assert_select "#hero", 1
  end

  test "should display product nav" do
    get :index
    assert_select ".nav-list"
  end

  test "should display a footer" do
    get :index
    assert_select "footer", 1
  end

  test "should display a menu" do
    get :index
    assert_select ".container-menu", 1
  end

  test "should display a logo" do
    get :index
    assert_select ".container-logo", 1
  end

  test "should display site credits" do
    get :index
    assert_select ".row-humans", 1
  end

  test "should get store" do
    get :store
    assert_response :success
  end

end
