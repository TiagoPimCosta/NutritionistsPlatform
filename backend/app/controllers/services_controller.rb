class ServicesController < ApplicationController
  before_action :set_service, only: %i[ show update destroy ]

  # GET /services
  def index
    @services = Service.all

    render json: @services
  end

  # GET /services/1
  def show
    return render json: [ "invalid service" ], status: :unprocessable_entity if @service.blank?
    render json: @service
  end

  # POST /services
  def create
    @service = Service.new(service_params)

    if @service.save
      render json: @service, status: :created, location: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /services/1
  def update
    return render json: [ "invalid service" ], status: :unprocessable_entity if @service.blank?
    if @service.update(service_params)
      render json: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # DELETE /services/1
  def destroy
    return render json: [ "invalid service" ], status: :unprocessable_entity if @service.blank?
    @service.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.expect(service: [ :name ])
    end
end
