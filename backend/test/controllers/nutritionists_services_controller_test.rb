require "test_helper"

class NutritionistsServicesControllerTest < ActionDispatch::IntegrationTest
  test "paginates the offerings" do
    3.times { create_offering }

    get nutritionists_services_url(page: 1, per_page: 2), as: :json

    assert_response :success
    assert_equal 2, response.parsed_body["items"].size
    assert_equal 3, response.parsed_body["total_count"]
    assert_equal 2, response.parsed_body["total_pages"]
  end

  test "filters by nutritionist name" do
    wanted = Nutritionist.create!(name: "Carla Santos", title: "Nutricionista", license_number: "2963N")
    create_offering(nutritionist: wanted)
    create_offering

    get nutritionists_services_url(filter: "carla"), as: :json

    assert_equal [ "Carla Santos" ], response.parsed_body["items"].map { |i| i["nutritionist"]["name"] }
  end

  test "filters by service name" do
    create_offering(service: Service.create!(name: "Desportivo"))
    create_offering(service: Service.create!(name: "Infantil"))

    get nutritionists_services_url(filter: "desport"), as: :json

    assert_equal [ "Desportivo" ], response.parsed_body["items"].map { |i| i["service"]["name"] }
  end

  test "exposes the license number and duration the UI used to hardcode" do
    create_offering(duration_minutes: 45)

    get nutritionists_services_url, as: :json

    item = response.parsed_body["items"].first
    assert item["nutritionist"]["license_number"].present?
    assert_equal 45, item["duration_minutes"]
  end
end
