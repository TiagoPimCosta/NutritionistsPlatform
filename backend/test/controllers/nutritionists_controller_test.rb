require "test_helper"

class NutritionistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nutritionist = nutritionists(:one)
  end

  test "should get index" do
    get nutritionists_url, as: :json
    assert_response :success
  end

  test "should create nutritionist" do
    assert_difference("Nutritionist.count") do
      post nutritionists_url, params: { nutritionist: { address: @nutritionist.address, name: @nutritionist.name, price: @nutritionist.price } }, as: :json
    end

    assert_response :created
  end

  test "should show nutritionist" do
    get nutritionist_url(@nutritionist), as: :json
    assert_response :success
  end

  test "should update nutritionist" do
    patch nutritionist_url(@nutritionist), params: { nutritionist: { address: @nutritionist.address, name: @nutritionist.name, price: @nutritionist.price } }, as: :json
    assert_response :success
  end

  test "should destroy nutritionist" do
    assert_difference("Nutritionist.count", -1) do
      delete nutritionist_url(@nutritionist), as: :json
    end

    assert_response :no_content
  end
end
