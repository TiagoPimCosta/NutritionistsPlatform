class NutritionistsController < ApplicationController
  # GET /nutritionists/:id/pending_requests
  def pending_requests
    service = NutritionistsServices::PendingRequests.new(params[:id])
    result = service.call
    if result[:success]
      render json: result[:records], status: :ok
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end
end
