require 'test_helper'

class OfertaControllerTest < ActionController::TestCase
  setup do
    @ofertum = oferta(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:oferta)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ofertum" do
    assert_difference('Ofertum.count') do
      post :create, ofertum: { course_code: @ofertum.course_code, description: @ofertum.description, end_date: @ofertum.end_date, maximum_subscriptions: @ofertum.maximum_subscriptions, start_date: @ofertum.start_date }
    end

    assert_redirected_to ofertum_path(assigns(:ofertum))
  end

  test "should show ofertum" do
    get :show, id: @ofertum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ofertum
    assert_response :success
  end

  test "should update ofertum" do
    put :update, id: @ofertum, ofertum: { course_code: @ofertum.course_code, description: @ofertum.description, end_date: @ofertum.end_date, maximum_subscriptions: @ofertum.maximum_subscriptions, start_date: @ofertum.start_date }
    assert_redirected_to ofertum_path(assigns(:ofertum))
  end

  test "should destroy ofertum" do
    assert_difference('Ofertum.count', -1) do
      delete :destroy, id: @ofertum
    end

    assert_redirected_to oferta_path
  end
end
