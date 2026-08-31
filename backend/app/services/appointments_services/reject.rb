# frozen_string_literal: true

module AppointmentsServices
  class Reject
    ConflictError = Class.new(StandardError)

    def initialize(appointment_id)
      @appointment_id = appointment_id
    end

    def call
      appointment = reject!

      { success: true, records: appointment, errors: nil, code: nil }
    rescue ActiveRecord::RecordNotFound => e
      failure(e.message, :not_found)
    rescue ConflictError => e
      failure(e.message, :conflict)
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message, :invalid)
    end

    private

    attr_reader :appointment_id

    def reject!
      Appointment.transaction do
        appointment = Appointment.lock.find(appointment_id)

        raise ConflictError, "Appointment is already #{appointment.status}" unless appointment.pending?

        appointment.rejected!
        NotificationMailer.with(appointment: appointment).reject_appointment_email.deliver_later
        appointment
      end
    end

    def failure(message, code)
      { success: false, records: nil, errors: [ { message: message } ], code: code }
    end
  end
end
