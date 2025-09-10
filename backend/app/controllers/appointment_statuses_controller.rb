class AppointmentStatusesController < ApplicationController
  before_action :set_appointment_status, only: %i[ show update destroy ]

  # GET /appointment_statuses
  def index
    @appointment_statuses = AppointmentStatus.all

    render json: @appointment_statuses
  end

  # GET /appointment_statuses/1
  def show
    render json: @appointment_status
  end

  # POST /appointment_statuses
  def create
    @appointment_status = AppointmentStatus.new(appointment_status_params)

    if @appointment_status.save
      render json: @appointment_status, status: :created, location: @appointment_status
    else
      render json: @appointment_status.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointment_statuses/1
  def update
    if @appointment_status.update(appointment_status_params)
      render json: @appointment_status
    else
      render json: @appointment_status.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appointment_statuses/1
  def destroy
    @appointment_status.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment_status
      @appointment_status = AppointmentStatus.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def appointment_status_params
      params.expect(appointment_status: [ :status ])
    end
end
