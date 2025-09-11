class NutritionistsServicesController < ApplicationController
  # GET /nutritionists_services
  def index
    service = NutritionistsServicesServices::GetAllNutritionistsServices.new(index_params)
    result = service.call
    if result[:success]
      render json: result[:records], status: :ok
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  private
    def index_params
      params.permit([ :filter, :page, :per_page ])
    end
end
