class NutritionistsServicesController < ApplicationController
  before_action :set_nutritionists_service, only: %i[ show update destroy ]

  # GET /nutritionists_services
  def index
    @nutritionists_services = NutritionistsService.all

    render json: @nutritionists_services
  end

  # GET /nutritionists_services/1
  def show
    render json: @nutritionists_service
  end

  # POST /nutritionists_services
  def create
    @nutritionists_service = NutritionistsService.new(nutritionists_service_params)

    if @nutritionists_service.save
      render json: @nutritionists_service, status: :created, location: @nutritionists_service
    else
      render json: @nutritionists_service.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /nutritionists_services/1
  def update
    if @nutritionists_service.update(nutritionists_service_params)
      render json: @nutritionists_service
    else
      render json: @nutritionists_service.errors, status: :unprocessable_entity
    end
  end

  # DELETE /nutritionists_services/1
  def destroy
    @nutritionists_service.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nutritionists_service
      @nutritionists_service = NutritionistsService.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def nutritionists_service_params
      params.expect(nutritionists_service: [ :nutritionist_id, :service_id ])
    end
end
