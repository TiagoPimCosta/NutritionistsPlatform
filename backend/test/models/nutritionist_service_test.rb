require "test_helper"

class NutritionistServiceTest < ActiveSupport::TestCase
  test "requires a positive price and duration" do
    offering = NutritionistService.new(
      nutritionist: Nutritionist.create!(name: "Carla", title: "Nutricionista", license_number: "2963N"),
      service: Service.create!(name: "Dietético"),
      street: "Rua de Teste 1", city: "Braga", price_cents: 0, duration_minutes: 0
    )

    assert_not offering.valid?
    assert_includes offering.errors[:price_cents], "must be greater than 0"
    assert_includes offering.errors[:duration_minutes], "must be greater than 0"
  end

  test "does not offer the same service twice in the same city" do
    offering = create_offering(city: "Braga")

    duplicate = NutritionistService.new(
      nutritionist: offering.nutritionist, service: offering.service,
      street: "Outra Rua", city: "Braga", price_cents: 3000, duration_minutes: 60
    )

    assert_not duplicate.valid?
  end

  test "exposes the duration as a length of time" do
    assert_equal 45.minutes, create_offering(duration_minutes: 45).duration
  end
end
