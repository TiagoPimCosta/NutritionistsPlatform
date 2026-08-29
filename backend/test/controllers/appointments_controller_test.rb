require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @offering = create_offering(duration_minutes: 45)
    @slot = 3.days.from_now.change(hour: 10, min: 0)
  end

  test "creates an appointment" do
    assert_difference "Appointment.count", 1 do
      post appointments_url, as: :json, params: {
        name: "Ana Martins", email: "ana@example.com",
        nutritionist_service_id: @offering.id, starts_at: @slot
      }
    end

    assert_response :created
  end

  test "a second request from the same guest cancels the first" do
    post appointments_url, as: :json, params: {
      name: "Ana Martins", email: "ana@example.com",
      nutritionist_service_id: @offering.id, starts_at: @slot
    }
    first = Appointment.order(:created_at).last

    post appointments_url, as: :json, params: {
      name: "Ana Martins", email: "ana@example.com",
      nutritionist_service_id: @offering.id, starts_at: @slot + 2.days
    }

    assert_response :created
    assert_predicate first.reload, :cancelled?
    assert_equal 1, first.guest.appointments.pending.count
    assert_equal @slot + 2.days, first.guest.appointments.pending.first.starts_at
  end

  test "returns 422 when the slot is in the past" do
    post appointments_url, as: :json, params: {
      name: "Ana Martins", email: "ana@example.com",
      nutritionist_service_id: @offering.id, starts_at: 1.hour.ago
    }

    assert_response :unprocessable_content
  end

  test "accepting rejects the overlapping pending requests" do
    accepted = request_appointment(@offering, create_guest, @slot)
    overlapping = request_appointment(@offering, create_guest, @slot + 30.minutes)

    post accept_appointment_url(accepted), as: :json

    assert_response :success
    assert_predicate accepted.reload, :accepted?
    assert_predicate overlapping.reload, :rejected?
  end

  test "rejecting marks the request as rejected" do
    appointment = request_appointment(@offering, create_guest, @slot)

    post reject_appointment_url(appointment), as: :json

    assert_response :success
    assert_predicate appointment.reload, :rejected?
  end

  test "returns 422 for an unknown appointment" do
    post accept_appointment_url(SecureRandom.uuid), as: :json

    assert_response :unprocessable_content
  end
end
