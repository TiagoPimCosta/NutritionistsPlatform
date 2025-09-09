class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show update destroy accept reject]

  # GET /appointments
  def index
    @appointments = Appointment.includes(:guest, :nutritionist).all

    render json: @appointments.as_json(include: {
      guest: { only: [ :name ] },
      nutritionist: { only: [ :name ] }
    })
  end

  # POST /appointments
  def create
    @appointment = Appointment.new(
      {
        date: appointment_params[:date],
        status_id: 0,
        nutritionist_id: appointment_params[:nutritionist_id],
        guest: initial
      })

    if @appointment.save
      render json: @appointment, status: :created, location: @appointment
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # POST /appointments/:id/accept
  def accept
    apps = Appointments.where(nutritionist: @appointment.nutritionist, date: @appointment.date)
    apps.update_all(status: 1)
    @appointment.update(status: 2)
    render json: { status: 200, message: "Appointment created" }
  end

  # POST /appointments/:id/reject
  def reject
      render json: { string: "teste" }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.expect([ :date, :name, :email, :nutritionist_id ])
    end

    def initial
      email = appointment_params[:email]
      name = appointment_params[:name]
      guest = Guest.find_by(email: email)

      return guest unless guest.blank?

      Guest.create(name: name, email: email)
    end
end
