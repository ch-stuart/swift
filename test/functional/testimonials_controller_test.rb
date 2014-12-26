require 'test_helper'

class TestimonialsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    sign_in users(:admin)
    @testimonial = testimonials(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:testimonials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create testimonial" do
    assert_difference('Testimonial.count') do
      post :create, :testimonial => @testimonial.attributes.slice("body", "author", "product_id")
    end

    assert_redirected_to testimonial_path(assigns(:testimonial))
  end

  test "should show testimonial" do
    get :show, :id => @testimonial.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @testimonial.to_param
    assert_response :success
  end

  test "should update testimonial" do
    put :update, :id => @testimonial.to_param, :testimonial => @testimonial.attributes.slice("body", "author", "product_id")
    assert_redirected_to testimonial_path(assigns(:testimonial))
  end

  test "should destroy testimonial" do
    assert_difference('Testimonial.count', -1) do
      delete :destroy, :id => @testimonial.to_param
    end

    assert_redirected_to testimonials_path
  end
end
