require "test_helper"

class FoodDrinksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get food_drinks_index_url
    assert_response :success
  end

  test "should get new" do
    get food_drinks_new_url
    assert_response :success
  end

  test "should get create" do
    get food_drinks_create_url
    assert_response :success
  end

  test "should get show" do
    get food_drinks_show_url
    assert_response :success
  end
end
