require "test_helper"

module AppointmentsServices
  class ConcurrencyTest < ActiveSupport::TestCase
    self.use_transactional_tests = false

    setup do
      @offering = create_offering(duration_minutes: 45)
      @slot = 3.days.from_now.change(hour: 10, min: 0)
    end

    teardown do
      Appointment.delete_all
      NutritionistService.delete_all
      Guest.delete_all
      Nutritionist.delete_all
      Service.delete_all
    end

    test "two accepts racing over the same slot cannot both win" do
      first = request_appointment(@offering, create_guest, @slot)
      second = request_appointment(@offering, create_guest, @slot + 30.minutes)

      results = race(first.id, second.id) { |id| Accept.new(id).call }

      assert_equal 1, [ first, second ].count { |appointment| appointment.reload.accepted? },
                   "exactly one of two overlapping requests may end up accepted"
      assert_equal 1, results.count { |result| result[:success] }
      assert_predicate [ first, second ].find { |a| !a.accepted? }.reload, :rejected?
    end

    test "requests booked through different services of the same nutritionist race too" do
      other = create_offering(nutritionist: @offering.nutritionist, city: "Porto")
      first = request_appointment(@offering, create_guest, @slot)
      second = request_appointment(other, create_guest, @slot + 15.minutes)

      race(first.id, second.id) { |id| Accept.new(id).call }

      assert_equal 1, [ first, second ].count { |appointment| appointment.reload.accepted? }
    end

    test "two first requests from the same guest leave exactly one pending" do
      params = lambda do |starts_at|
        { name: "Ana Martins", email: "ana@example.com",
          nutritionist_service_id: @offering.id, starts_at: starts_at }
      end

      race(@slot, @slot + 1.day) { |starts_at| Create.new(params.call(starts_at)).call }

      assert_equal 1, Guest.count, "the unique index on lower(email) settles the tie"
      assert_equal 1, Appointment.pending.count, "a guest may only have one pending request"
    end

    test "the database refuses overlapping accepted appointments even when the service is bypassed" do
      accepted = request_appointment(@offering, create_guest, @slot)
      accepted.update_column(:status, Appointment.statuses[:accepted])
      intruder = request_appointment(@offering, create_guest, @slot + 30.minutes)

      error = assert_raises(ActiveRecord::StatementInvalid) do
        intruder.update_column(:status, Appointment.statuses[:accepted])
      end

      assert_kind_of PG::ExclusionViolation, error.cause
    end

    test "back to back appointments are not an overlap for the constraint" do
      first = request_appointment(@offering, create_guest, @slot)
      second = request_appointment(@offering, create_guest, @slot + 45.minutes)

      first.update_column(:status, Appointment.statuses[:accepted])

      assert_nothing_raised do
        second.update_column(:status, Appointment.statuses[:accepted])
      end
    end

    test "a failure while rejecting the conflicts rolls the acceptance back" do
      accepted = request_appointment(@offering, create_guest, @slot)
      request_appointment(@offering, create_guest, @slot + 30.minutes)

      Reject.stub(:new, ->(_id) { raise "the mailer fell over" }) do
        assert_raises(RuntimeError) { Accept.new(accepted.id).call }
      end

      assert_predicate accepted.reload, :pending?,
                       "an acceptance whose cascade failed must not be left committed"
    end

    test "accepting an already accepted request is a conflict, not a second cascade" do
      accepted = request_appointment(@offering, create_guest, @slot)
      Accept.new(accepted.id).call
      later = request_appointment(@offering, create_guest, @slot + 30.minutes)

      result = Accept.new(accepted.id).call

      assert_not result[:success]
      assert_equal :conflict, result[:code]
      assert_predicate later.reload, :pending?, "the second accept must not cascade again"
    end

    private

    def race(*arguments)
      gate = Queue.new
      threads = arguments.map do |argument|
        Thread.new do
          gate.pop
          ActiveRecord::Base.connection_pool.with_connection { yield(argument) }
        end
      end

      arguments.size.times { gate << :go }
      threads.map(&:value)
    end
  end
end
