# frozen_string_literal: true

module AppointmentsServices
  class Create
    def initialize(create_appointment_params)
      @create_appointment_params = create_appointment_params
    end

    def call
      apps = Appointment.where(guest: appointment.guest, status_id: 1)
      apps.update_all(status_id: 4)
      {
        success: appointment.save,
        records: nil,
        errors: nil
      }
    rescue => e
      {
        success: false,
        records: nil,
        errors: [ message: e.message ]
      }
    end

    private

    attr_reader :create_appointment_params

    def appointment
      @appointment ||= begin
        Appointment.new(
          {
            date: date,
            status_id: 1,
            nutritionist_id: nutritionist_id,
            guest: setup_guest
          })
      end
    end

    def setup_guest
      guest = Guest.find_by(email: email)

      if guest.present? && name.present? && guest.name != name
        guest.update(name: name)
      end

      return guest unless guest.blank?

      Guest.create(name: name, email: email)
    end

    def date
      create_appointment_params[:date]
    end

    def name
      create_appointment_params[:name]
    end

    def email
      create_appointment_params[:email]
    end

    def nutritionist_id
      create_appointment_params[:nutritionist_id]
    end
  end
end
