require 'test_helper'

class ImportationAttachmentsControllerTest < ActionController::TestCase
  setup do
    @importation_attachment = importation_attachments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:importation_attachments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create importation_attachment" do
    assert_difference('ImportationAttachment.count') do
      post :create, importation_attachment: { collection_name: @importation_attachment.collection_name, content_type: @importation_attachment.content_type, data: @importation_attachment.data, filename: @importation_attachment.filename, importation_id: @importation_attachment.importation_id }
    end

    assert_redirected_to importation_attachment_path(assigns(:importation_attachment))
  end

  test "should show importation_attachment" do
    get :show, id: @importation_attachment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @importation_attachment
    assert_response :success
  end

  test "should update importation_attachment" do
    put :update, id: @importation_attachment, importation_attachment: { collection_name: @importation_attachment.collection_name, content_type: @importation_attachment.content_type, data: @importation_attachment.data, filename: @importation_attachment.filename, importation_id: @importation_attachment.importation_id }
    assert_redirected_to importation_attachment_path(assigns(:importation_attachment))
  end

  test "should destroy importation_attachment" do
    assert_difference('ImportationAttachment.count', -1) do
      delete :destroy, id: @importation_attachment
    end

    assert_redirected_to importation_attachments_path
  end
end
