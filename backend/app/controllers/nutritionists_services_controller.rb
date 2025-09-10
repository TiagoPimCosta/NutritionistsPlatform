class NutritionistsServicesController < ApplicationController
  before_action :set_nutritionists_service, only: %i[ show update destroy ]

  # GET /nutritionists_services
  def index
    filter = params[:filter].to_s.strip
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 3

    @nutritionists_services = NutritionistsService.includes(:nutritionist, :service).all

    if filter.present?
      @nutritionists_services = @nutritionists_services
        .joins(:nutritionist, :service)
        .where(
          "nutritionists.name ILIKE :filter OR services.name ILIKE :filter",
          filter: "%#{filter}%"
        ).distinct
    end

    total_count = @nutritionists_services.count
    @nutritionists_services = @nutritionists_services.offset((page - 1) * per_page).limit(per_page)


    render json: {
      items: @nutritionists_services.as_json(
        include: {
          nutritionist: { only: [ :id, :name ] },
          service: { only: [ :name ] }
        }
      ),
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: (total_count / per_page.to_f).ceil
    }
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
