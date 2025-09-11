# frozen_string_literal: true

module AppointmentsServices
  class Reject
    def initialize(appointment_id)
      @appointment_id = appointment_id
    end

    def call
      setup_appointment
      reject_appointment
      {
        success: @appointment.errors.empty?,
        records: nil,
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

    attr_reader :appointment_id

    def reject_appointment
      @appointment.update(status_id: 3)
    end

    def setup_appointment
      @appointment = Appointment.find(appointment_id)
    end
  end
end
