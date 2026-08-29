require "test_helper"

module AppointmentsServices
  class CreateTest < ActiveSupport::TestCase
    setup do
      @offering = create_offering(duration_minutes: 45)
      @slot = 3.days.from_now.change(hour: 10, min: 0)
    end

    def params(email:, name: "Ana Martins", starts_at: nil, offering: nil)
      { name: name, email: email, nutritionist_service_id: (offering || @offering).id,
        starts_at: starts_at || @slot }
    end

    test "creates the guest on a first request" do
      assert_difference "Guest.count", 1 do
        assert Create.new(params(email: "ana@example.com")).call[:success]
      end
    end

    test "reuses a guest that already booked before" do
      create_guest(email: "ana@example.com")

      assert_no_difference "Guest.count" do
        Create.new(params(email: "ana@example.com")).call
      end
    end

    test "cancels the previous pending request from the same guest" do
      guest = create_guest(email: "ana@example.com")
      previous = request_appointment(@offering, guest, @slot + 2.days)

      Create.new(params(email: "ana@example.com")).call

      assert_predicate previous.reload, :cancelled?
      assert_equal 1, guest.appointments.pending.count
    end

    test "leaves other guests' pending requests alone" do
      other = request_appointment(@offering, create_guest(email: "joao@example.com"), @slot + 1.day)

      Create.new(params(email: "ana@example.com")).call

      assert_predicate other.reload, :pending?
    end

    test "reports validation errors instead of raising" do
      result = Create.new(params(email: "ana@example.com", starts_at: 1.hour.ago)).call

      assert_not result[:success]
      assert_match(/must be in the future/, result[:errors].first[:message])
    end
  end
end
