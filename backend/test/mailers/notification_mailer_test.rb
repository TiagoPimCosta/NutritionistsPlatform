require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  setup do
    @offering = create_offering(duration_minutes: 45)
    @appointment = request_appointment(@offering, create_guest(email: "ana@example.com"),
                                       3.days.from_now.change(hour: 10, min: 0))
  end

  test "the acceptance email reaches the guest with the details of the booking" do
    email = NotificationMailer.with(appointment: @appointment).accept_appointment_email

    assert_equal [ "ana@example.com" ], email.to
    assert_equal [ "notifications@example.com" ], email.from
    assert_match @offering.nutritionist.name, email.subject
    assert_match "10:00", email.body.to_s
    assert_match "10:45", email.body.to_s
    assert_match @offering.city, email.body.to_s
  end

  test "the rejection email reaches the guest" do
    email = NotificationMailer.with(appointment: @appointment).reject_appointment_email

    assert_equal [ "ana@example.com" ], email.to
    assert_match @appointment.guest.name, email.body.to_s
  end

  test "both templates resolve" do
    assert_nothing_raised do
      NotificationMailer.with(appointment: @appointment).accept_appointment_email.body
      NotificationMailer.with(appointment: @appointment).reject_appointment_email.body
    end
  end
end
