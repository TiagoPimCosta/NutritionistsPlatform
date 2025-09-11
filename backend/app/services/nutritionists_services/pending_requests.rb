# frozen_string_literal: true

module NutritionistsServices
  class PendingRequests
    def initialize(nutritionist_id)
      @nutritionist_id = nutritionist_id
    end

    def call
      nutritionist = Nutritionist.find(@nutritionist_id)
      appointments = Appointment.where(nutritionist_id: nutritionist.id, status_id: 1).includes(:guest)
      {
        success: true,
        records: appointments.as_json(include: { guest: { only: [ :id, :name ] } }),
        errors: nil
      }
    rescue ActiveRecord::RecordNotFound => e
      {
        success: false,
        records: nil,
        errors: [ message: e.message ]
      }
    rescue => e
      {
        success: false,
        records: nil,
        errors: [ message: e.message ]
      }
    end
    private
  end
end
