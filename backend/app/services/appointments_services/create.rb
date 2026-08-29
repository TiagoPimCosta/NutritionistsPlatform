# frozen_string_literal: true

module AppointmentsServices
  class Create
    def initialize(create_appointment_params)
      @create_appointment_params = create_appointment_params
    end

    def call
      Appointment.where(guest: appointment.guest).pending.update_all(status: Appointment.statuses[:cancelled])

      {
        success: appointment.save,
        records: appointment,
        errors: appointment.errors.full_messages.map { |message| { message: message } }.presence
      }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, records: nil, errors: [ { message: e.message } ] }
    end

    private

    attr_reader :create_appointment_params

    def appointment
      @appointment ||= Appointment.new(
        guest: setup_guest,
        nutritionist_service: NutritionistService.find(nutritionist_service_id),
        starts_at: starts_at
      )
    end

    def setup_guest
      guest = Guest.find_by(email: email.to_s.strip.downcase)
      return Guest.new(name: name, email: email) if guest.blank?

      guest.update(name: name) if name.present? && guest.name != name
      guest
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
