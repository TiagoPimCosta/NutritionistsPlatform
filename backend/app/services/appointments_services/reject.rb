# frozen_string_literal: true

module AppointmentsServices
  class Reject
    def initialize(appointment_id)
      @appointment_id = appointment_id
    end

    def call
      appointment = Appointment.find(appointment_id)
      appointment.rejected!
      # Send Reject Email
      {
        success: true,
        records: appointment,
        errors: nil
      }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, records: nil, errors: [ { message: e.message } ] }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, records: nil, errors: [ { message: e.message } ] }
    end

    private

    attr_reader :appointment_id
  end
end
