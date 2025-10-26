require "test_helper"

class Admin::SuggestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_suggestions_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_suggestions_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_suggestions_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_suggestions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_suggestions_destroy_url
    assert_response :success
  end
end
