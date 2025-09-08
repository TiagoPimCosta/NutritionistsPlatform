require "test_helper"

class NutritionistsServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nutritionists_service = nutritionists_services(:one)
  end

  test "should get index" do
    get nutritionists_services_url, as: :json
    assert_response :success
  end

  test "should create nutritionists_service" do
    assert_difference("NutritionistsService.count") do
      post nutritionists_services_url, params: { nutritionists_service: { nutritionist_id: @nutritionists_service.nutritionist_id, service_id: @nutritionists_service.service_id } }, as: :json
    end

    assert_response :created
  end

  test "should show nutritionists_service" do
    get nutritionists_service_url(@nutritionists_service), as: :json
    assert_response :success
  end

  test "should update nutritionists_service" do
    patch nutritionists_service_url(@nutritionists_service), params: { nutritionists_service: { nutritionist_id: @nutritionists_service.nutritionist_id, service_id: @nutritionists_service.service_id } }, as: :json
    assert_response :success
  end

  test "should destroy nutritionists_service" do
    assert_difference("NutritionistsService.count", -1) do
      delete nutritionists_service_url(@nutritionists_service), as: :json
    end

    assert_response :no_content
  end
end
