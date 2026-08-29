require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  test "derives ends_at from the duration of the requested service" do
    offering = create_offering(duration_minutes: 45)
    starts_at = 3.days.from_now.change(hour: 10, min: 0)

    appointment = request_appointment(offering, create_guest, starts_at)

    assert_equal starts_at + 45.minutes, appointment.ends_at
  end

  test "starts as pending" do
    appointment = request_appointment(create_offering, create_guest, 3.days.from_now)

    assert_predicate appointment, :pending?
  end

  test "rejects a booking in the past" do
    appointment = Appointment.new(
      nutritionist_service: create_offering, guest: create_guest, starts_at: 1.hour.ago
    )

    assert_not appointment.valid?
    assert_includes appointment.errors[:starts_at], "must be in the future"
  end

  test "reaches the nutritionist through the service" do
    offering = create_offering
    appointment = request_appointment(offering, create_guest, 3.days.from_now)

    assert_equal offering.nutritionist, appointment.nutritionist
  end

  test "for_nutritionist finds requests booked through any of their services" do
    nutritionist = Nutritionist.create!(name: "Carla", title: "Nutricionista", license_number: "1111N")
    first = create_offering(nutritionist: nutritionist, city: "Braga")
    second = create_offering(nutritionist: nutritionist, city: "Porto")
    other = create_offering

    request_appointment(first, create_guest, 3.days.from_now)
    request_appointment(second, create_guest, 4.days.from_now)
    request_appointment(other, create_guest, 5.days.from_now)

    assert_equal 2, Appointment.for_nutritionist(nutritionist.id).count
  end

  test "overlapping matches a booking that starts inside another" do
    offering = create_offering(duration_minutes: 45)
    starts_at = 3.days.from_now.change(hour: 10, min: 0)
    request_appointment(offering, create_guest, starts_at)

    overlapping = Appointment.overlapping(starts_at + 30.minutes, starts_at + 75.minutes)

    assert_equal 1, overlapping.count
  end

  test "overlapping ignores a booking that starts exactly when another ends" do
    offering = create_offering(duration_minutes: 45)
    starts_at = 3.days.from_now.change(hour: 10, min: 0)
    request_appointment(offering, create_guest, starts_at)

    back_to_back = Appointment.overlapping(starts_at + 45.minutes, starts_at + 90.minutes)

    assert_equal 0, back_to_back.count, "a nutritionist must be able to book consecutive slots"
  end

  test "the database refuses an appointment that ends before it starts" do
    appointment = request_appointment(create_offering, create_guest, 3.days.from_now)

    assert_raises ActiveRecord::StatementInvalid do
      appointment.update_column(:ends_at, appointment.starts_at - 1.minute)
    end
  end
end
