class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ accept reject ]

  # GET /appointments
  def index
    @appointments = Appointment.includes(:guest, :nutritionist).all

    render json: @appointments.as_json(include: {
      guest: { only: [ :name ] },
      nutritionist: { only: [ :name ] }
    })
  end

  # GET /appointments/1
  def show
    render json: @appointment
  end

  # POST /appointments
  def create
    @appointment = Appointment.new(
      {
        date: appointment_params[:date],
        status_id: 1,
        nutritionist_id: appointment_params[:nutritionist_id],
        guest: setup_guest
      })

      if @appointment.save
        render json: { status: 201, message: "Appointment created", id: @appointment.id }, status: :created
      else
        render json: @appointment.errors, message: "Error creating appointment", status: :unprocessable_entity
      end
  end

  # POST /appointments/:id/accept
  def accept
    apps = Appointment.where(nutritionist: @appointment.nutritionist, date: @appointment.date)
    apps.update_all(status_id: 1)
    @appointment.update(status_id: 2)
    render json: { status: 200, message: "Appointment created" }
  end

  # POST /appointments/:id/reject
  def reject
      render json: { string: "teste" }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.permit([ :date, :name, :email, :nutritionist_id ])
    end

    def setup_guest
      email = appointment_params[:email]
      name = appointment_params[:name]
      guest = Guest.find_by(email: email)

      return guest unless guest.blank?

      Guest.create(name: name, email: email)
    end
end
