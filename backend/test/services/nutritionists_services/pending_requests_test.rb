require "test_helper"

module NutritionistsServices
  class PendingRequestsTest < ActiveSupport::TestCase
    setup do
      @offering = create_offering(duration_minutes: 45)
      @nutritionist = @offering.nutritionist
      @slot = 3.days.from_now.change(hour: 10, min: 0)
    end

    test "returns only the pending requests, oldest slot first" do
      later = request_appointment(@offering, create_guest, @slot + 2.hours)
      earlier = request_appointment(@offering, create_guest, @slot)
      request_appointment(@offering, create_guest, @slot + 1.day).rejected!

      records = PendingRequests.new(@nutritionist.id).call[:records]

      assert_equal [ earlier.id, later.id ], records.pluck(:id)
    end

    test "includes the guest email and the requested interval" do
      request_appointment(@offering, create_guest(name: "Ana Martins", email: "ana@example.com"), @slot)

      record = PendingRequests.new(@nutritionist.id).call[:records].first

      assert_equal "Ana Martins", record[:guest][:name]
      assert_equal "ana@example.com", record[:guest][:email]
      assert_equal @slot + 45.minutes, record[:ends_at]
    end

    test "reports a missing nutritionist instead of raising" do
      result = PendingRequests.new(SecureRandom.uuid).call

      assert_not result[:success]
    end
  end
end
