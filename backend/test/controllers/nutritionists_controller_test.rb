require "test_helper"

class NutritionistsControllerTest < ActionDispatch::IntegrationTest
  test "lists the pending requests of a nutritionist" do
    offering = create_offering
    request_appointment(offering, create_guest(name: "Ana Martins"), 3.days.from_now)

    get pending_requests_nutritionist_url(offering.nutritionist), as: :json

    assert_response :success
    assert_equal "Ana Martins", response.parsed_body.first["guest"]["name"]
  end

  test "returns 422 for an unknown nutritionist" do
    get pending_requests_nutritionist_url(SecureRandom.uuid), as: :json

    assert_response :unprocessable_content
  end
end
