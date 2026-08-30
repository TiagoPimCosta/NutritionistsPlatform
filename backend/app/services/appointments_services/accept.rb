# frozen_string_literal: true

module AppointmentsServices
  class Accept
    ConflictError = Class.new(StandardError)

    def initialize(appointment_id)
      @appointment_id = appointment_id
    end

    def call
      appointment = accept!

      { success: true, records: appointment, errors: nil, code: nil }
    rescue ActiveRecord::RecordNotFound => e
      failure(e.message, :not_found)
    rescue ConflictError => e
      failure(e.message, :conflict)
    rescue ActiveRecord::StatementInvalid => e
      raise unless exclusion_violation?(e)

      failure("This time slot is no longer available", :conflict)
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message, :invalid)
    end

    private

    attr_reader :appointment_id

    def accept!
      Appointment.transaction do
        appointment = Appointment.find(appointment_id)

        lock_diary(appointment.nutritionist_id)

        appointment.reload

        raise ConflictError, "Appointment is already #{appointment.status}" unless appointment.pending?

        appointment.accepted!
        reject_overlapping(appointment)

        appointment
      end
    end

    def lock_diary(nutritionist_id)
      Nutritionist.lock.find(nutritionist_id)
    end

    def reject_overlapping(appointment)
      Appointment
        .for_nutritionist(appointment.nutritionist_id)
        .pending
        .where.not(id: appointment.id)
        .overlapping(appointment.starts_at, appointment.ends_at)
        .each { |conflicting| AppointmentsServices::Reject.new(conflicting.id).call }
    end

    def exclusion_violation?(error)
      error.cause.is_a?(PG::ExclusionViolation)
    end

    def failure(message, code)
      { success: false, records: nil, errors: [ { message: message } ], code: code }
    end
  end
end
