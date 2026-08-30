# frozen_string_literal: true

module AppointmentsServices
  class Create
    def initialize(create_appointment_params)
      @create_appointment_params = create_appointment_params
    end

    def call
      appointment = book!

      if appointment.persisted?
        { success: true, records: appointment, errors: nil, code: nil }
      else
        { success: false, records: appointment, errors: messages_from(appointment), code: :invalid }
      end
    rescue ActiveRecord::RecordNotFound => e
      failure(e.message, :not_found)
    rescue ActiveRecord::RecordInvalid => e
      { success: false, records: nil, errors: messages_from(e.record), code: :invalid }
    end

    private

    attr_reader :create_appointment_params

    def book!
      offering = NutritionistService.find(nutritionist_service_id)
      attempts = 0

      begin
        attempts += 1
        booked(offering)
      rescue ActiveRecord::RecordNotUnique
        raise if attempts > 1
        retry
      end
    end

    def booked(offering)
      appointment = nil

      Appointment.transaction do
        guest = resolve_guest
        appointment = Appointment.new(guest: guest, nutritionist_service: offering, starts_at: starts_at)

        raise ActiveRecord::Rollback unless appointment.save

        cancel_previous_pending(appointment)
      end

      appointment
    end

    def resolve_guest
      guest = Guest.lock.find_by(email: normalized_email)
      return Guest.create!(name: name, email: email) if guest.blank?

      guest.update!(name: name) if name.present? && guest.name != name
      guest
    end

    def cancel_previous_pending(appointment)
      Appointment
        .where(guest_id: appointment.guest_id)
        .pending
        .where.not(id: appointment.id)
        .update_all(status: Appointment.statuses[:cancelled], updated_at: Time.current)
    end

    def messages_from(appointment)
      appointment.errors.full_messages.map { |message| { message: message } }.presence
    end

    def failure(message, code)
      { success: false, records: nil, errors: [ { message: message } ], code: code }
    end

    def normalized_email
      email.to_s.strip.downcase
    end

    def starts_at
      create_appointment_params[:starts_at]
    end

    def name
      create_appointment_params[:name]
    end

    def email
      create_appointment_params[:email]
    end

    def nutritionist_service_id
      create_appointment_params[:nutritionist_service_id]
    end
  end
end
