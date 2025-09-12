# frozen_string_literal: true

module AppointmentsServices
  class Accept
    def initialize(appointment_id)
      @appointment_id = appointment_id
    end

    def call
      setup_appointment
      accepted = accept_appointment
      rejected = reject_pending_conflicting_appointments
      # Send Accept Email
      {
        success: accepted && rejected && @appointment.errors.empty?,
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

    def accept_appointment
      @appointment.update(status_id: 2)
    end

    def reject_pending_conflicting_appointments
      pending_conflicting_appointments = Appointment.where(
        nutritionist: @appointment.nutritionist,
        date: @appointment.date,
        status_id: 1
      )
      pending_conflicting_appointments.find_each do |conflicting_appt|
        success = AppointmentsServices::Reject.new(conflicting_appt.id).call
        return false unless success
      end
      true
    end

    def setup_appointment
      @appointment = Appointment.find(appointment_id)
    end
  end
end
