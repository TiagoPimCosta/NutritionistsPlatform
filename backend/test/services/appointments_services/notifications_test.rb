require "test_helper"

module AppointmentsServices
  class NotificationsTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    setup do
      ActionMailer::Base.deliveries.clear
      @offering = create_offering(duration_minutes: 45)
      @slot = 3.days.from_now.change(hour: 10, min: 0)
    end

    test "accepting emails the guest whose request was accepted" do
      appointment = request_appointment(@offering, create_guest(email: "ana@example.com"), @slot)

      perform_enqueued_jobs { Accept.new(appointment.id).call }

      assert_equal [ "ana@example.com" ], ActionMailer::Base.deliveries.last.to
    end

    test "the cascade emails every guest it turns away" do
      accepted = request_appointment(@offering, create_guest(email: "ana@example.com"), @slot)
      request_appointment(@offering, create_guest(email: "joao@example.com"), @slot + 30.minutes)

      perform_enqueued_jobs { Accept.new(accepted.id).call }

      recipients = ActionMailer::Base.deliveries.flat_map(&:to)
      assert_includes recipients, "ana@example.com"
      assert_includes recipients, "joao@example.com"
      assert_equal 2, ActionMailer::Base.deliveries.size
    end

    test "rejecting emails the guest" do
      appointment = request_appointment(@offering, create_guest(email: "ana@example.com"), @slot)

      perform_enqueued_jobs { Reject.new(appointment.id).call }

      assert_equal [ "ana@example.com" ], ActionMailer::Base.deliveries.last.to
    end

    test "nothing is emailed when the request has already been answered" do
      appointment = request_appointment(@offering, create_guest, @slot)
      Accept.new(appointment.id).call
      clear_enqueued_jobs

      assert_no_enqueued_jobs { Accept.new(appointment.id).call }
    end

    test "an acceptance that rolls back sends nothing" do
      appointment = request_appointment(@offering, create_guest, @slot)
      request_appointment(@offering, create_guest, @slot + 30.minutes)

      assert_no_enqueued_jobs do
        Reject.stub(:new, ->(_id) { raise "the cascade fell over" }) do
          assert_raises(RuntimeError) { Accept.new(appointment.id).call }
        end
      end

      assert_predicate appointment.reload, :pending?
    end
  end
end
