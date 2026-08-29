# frozen_string_literal: true

module NutritionistsServices
  class PendingRequests
    def initialize(nutritionist_id)
      @nutritionist_id = nutritionist_id
    end

    def call
      nutritionist = Nutritionist.find(@nutritionist_id)

      appointments = Appointment
        .for_nutritionist(nutritionist.id)
        .pending
        .includes(:guest, nutritionist_service: :service)
        .order(:starts_at)

      { success: true, records: appointments.map { |appointment| serialize(appointment) }, errors: nil }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, records: nil, errors: [ { message: e.message } ] }
    end

    private

    def serialize(appointment)
      {
        id: appointment.id,
        starts_at: appointment.starts_at,
        ends_at: appointment.ends_at,
        status: appointment.status,
        nutritionist_id: @nutritionist_id,
        service_name: appointment.nutritionist_service.service.name,
        guest: appointment.guest.slice(:id, :name, :email)
      }
    end
  end
end
