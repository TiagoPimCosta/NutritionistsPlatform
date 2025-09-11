class AppointmentsController < ApplicationController
  # POST /appointments
  def create
    service = AppointmentsServices::Create.new(create_appointment_params)
    result = service.call
    if result[:success]
      render json: { status: 201, message: "Appointment created" }, status: :created
    else
      render json: result[:errors], message: "Error creating appointment", status: :unprocessable_entity
    end
  end

  # POST /appointments/:id/accept
  def accept
    service = AppointmentsServices::Accept.new(params[:id])
    result = service.call
    if result[:success]
      render json: { status: 200, message: "Appointment accepted" }, status: :ok
    else
      render json: result[:errors], message: "Error accepted appointment", status: :unprocessable_entity
    end
  end

  # POST /appointments/:id/reject
  def reject
    service = AppointmentsServices::Reject.new(params[:id])
    result = service.call
    if result[:success]
      render json: { status: 200, message: "Appointment rejected" }, status: :ok
    else
      render json: result[:errors], message: "Error rejected appointment", status: :unprocessable_entity
    end
  end

  private
    def create_appointment_params
      params.permit([ :date, :name, :email, :nutritionist_id ])
    end
end
