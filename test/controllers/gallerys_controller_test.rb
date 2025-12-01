require "test_helper"

class GallerysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gallerys_index_url
    assert_response :success
  end
end
