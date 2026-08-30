class AppointmentsController < ApplicationController
  ERROR_STATUSES = { not_found: :not_found, conflict: :conflict }.freeze

  # POST /appointments
  def create
    result = AppointmentsServices::Create.new(create_appointment_params).call

    if result[:success]
      render json: { status: 201, message: "Appointment created" }, status: :created
    else
      render json: result[:errors], status: error_status(result)
    end
  end

  # POST /appointments/:id/accept
  def accept
    result = AppointmentsServices::Accept.new(params[:id]).call

    if result[:success]
      render json: { status: 200, message: "Appointment accepted" }, status: :ok
    else
      render json: result[:errors], status: error_status(result)
    end
  end

  # POST /appointments/:id/reject
  def reject
    result = AppointmentsServices::Reject.new(params[:id]).call

    if result[:success]
      render json: { status: 200, message: "Appointment rejected" }, status: :ok
    else
      render json: result[:errors], status: error_status(result)
    end
  end

  private
    def error_status(result)
      ERROR_STATUSES.fetch(result[:code], :unprocessable_content)
    end

    def create_appointment_params
      params.permit([ :starts_at, :name, :email, :nutritionist_service_id ])
    end
end
