require "test_helper"

module AppointmentsServices
  class AcceptTest < ActiveSupport::TestCase
    setup do
      @offering = create_offering(duration_minutes: 45)
      @slot = 3.days.from_now.change(hour: 10, min: 0)
    end

    test "accepts the request" do
      appointment = request_appointment(@offering, create_guest, @slot)

      result = Accept.new(appointment.id).call

      assert result[:success]
      assert_predicate appointment.reload, :accepted?
    end

    test "rejects the other pending requests that overlap it" do
      accepted = request_appointment(@offering, create_guest, @slot)
      overlapping = request_appointment(@offering, create_guest, @slot + 30.minutes)

      Accept.new(accepted.id).call

      assert_predicate overlapping.reload, :rejected?
    end

    test "leaves a request that does not overlap alone" do
      accepted = request_appointment(@offering, create_guest, @slot)
      later = request_appointment(@offering, create_guest, @slot + 45.minutes)

      Accept.new(accepted.id).call

      assert_predicate later.reload, :pending?, "back to back bookings must survive"
    end

    test "only touches the same nutritionist" do
      accepted = request_appointment(@offering, create_guest, @slot)
      elsewhere = request_appointment(create_offering, create_guest, @slot)

      Accept.new(accepted.id).call

      assert_predicate elsewhere.reload, :pending?
    end

    test "reaches overlapping requests booked through another service of the same nutritionist" do
      other_offering = create_offering(nutritionist: @offering.nutritionist, city: "Porto")
      accepted = request_appointment(@offering, create_guest, @slot)
      overlapping = request_appointment(other_offering, create_guest, @slot + 15.minutes)

      Accept.new(accepted.id).call

      assert_predicate overlapping.reload, :rejected?
    end

    test "reports a missing appointment instead of raising" do
      result = Accept.new(SecureRandom.uuid).call

      assert_not result[:success]
      assert_match(/Couldn't find Appointment/, result[:errors].first[:message])
    end
  end
end
