require 'test_helper'

class ImportationsControllerTest < ActionController::TestCase
  setup do
    @importation = importations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:importations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create importation" do
    assert_difference('Importation.count') do
      post :create, importation: { created_at: @importation.created_at, name: @importation.name, status: @importation.status }
    end

    assert_redirected_to importation_path(assigns(:importation))
  end

  test "should show importation" do
    get :show, id: @importation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @importation
    assert_response :success
  end

  test "should update importation" do
    put :update, id: @importation, importation: { created_at: @importation.created_at, name: @importation.name, status: @importation.status }
    assert_redirected_to importation_path(assigns(:importation))
  end

  test "should destroy importation" do
    assert_difference('Importation.count', -1) do
      delete :destroy, id: @importation
    end

    assert_redirected_to importations_path
  end
end
