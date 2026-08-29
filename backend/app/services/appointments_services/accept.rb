# frozen_string_literal: true

module AppointmentsServices
  class Accept
    def initialize(appointment_id)
      @appointment_id = appointment_id
    end

    def call
      setup_appointment
      @appointment.accepted!
      reject_overlapping_pending_appointments
      # Send Accept Email
      {
        success: true,
        records: @appointment,
        errors: nil
      }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, records: nil, errors: [ { message: e.message } ] }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, records: nil, errors: [ { message: e.message } ] }
    end

    private

    attr_reader :appointment_id

    def reject_overlapping_pending_appointments
      Appointment
        .for_nutritionist(@appointment.nutritionist.id)
        .pending
        .where.not(id: @appointment.id)
        .overlapping(@appointment.starts_at, @appointment.ends_at)
        .find_each { |conflicting| AppointmentsServices::Reject.new(conflicting.id).call }
    end

    def setup_appointment
      @appointment = Appointment.find(appointment_id)
    end
  end
end
