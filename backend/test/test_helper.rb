ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"

module ActiveSupport
  class TestCase
    parallelize(workers: 1)

    def create_offering(duration_minutes: 45, city: "Braga", nutritionist: nil, service: nil)
      NutritionistService.create!(
        nutritionist: nutritionist || Nutritionist.create!(
          name: "Nutricionista #{SecureRandom.hex(4)}", title: "Nutricionista",
        license_number: SecureRandom.hex(4)
        ),
        service: service || Service.create!(name: "Serviço #{SecureRandom.hex(4)}"),
        street: "Rua de Teste 1",
        city: city,
        price_cents: 2500,
        duration_minutes: duration_minutes
      )
    end

    def create_guest(name: "Ana Martins", email: nil)
      Guest.create!(name: name, email: email || "#{SecureRandom.hex(4)}@example.com")
    end

    def request_appointment(offering, guest, starts_at)
      Appointment.create!(nutritionist_service: offering, guest: guest, starts_at: starts_at)
    end
  end
end
