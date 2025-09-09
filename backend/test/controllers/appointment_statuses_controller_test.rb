require "test_helper"

class AppointmentStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appointment_status = appointment_statuses(:one)
  end

  test "should get index" do
    get appointment_statuses_url, as: :json
    assert_response :success
  end

  test "should create appointment_status" do
    assert_difference("AppointmentStatus.count") do
      post appointment_statuses_url, params: { appointment_status: { status: @appointment_status.status } }, as: :json
    end

    assert_response :created
  end

  test "should show appointment_status" do
    get appointment_status_url(@appointment_status), as: :json
    assert_response :success
  end

  test "should update appointment_status" do
    patch appointment_status_url(@appointment_status), params: { appointment_status: { status: @appointment_status.status } }, as: :json
    assert_response :success
  end

  test "should destroy appointment_status" do
    assert_difference("AppointmentStatus.count", -1) do
      delete appointment_status_url(@appointment_status), as: :json
    end

    assert_response :no_content
  end
end
