class NutritionistsController < ApplicationController
  before_action :set_nutritionist, only: %i[ show update destroy ]

  # GET /nutritionists
  def index
    filter = params[:filter].to_s.strip
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10

    @nutritionists = Nutritionist.includes(:services).all

    if filter.present?
      @nutritionists = @nutritionists
        .left_joins(:services)
        .where(
          "nutritionists.name ILIKE :filter OR services.name ILIKE :filter",
          filter: "%#{filter}%"
        ).order(:id).distinct
    end

    total_count = @nutritionists.count
    @nutritionists = @nutritionists.offset((page - 1) * per_page).limit(per_page)

    render json: {
      items: @nutritionists.as_json(include: { services: { only: [ :id, :name ] } }),
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: (total_count / per_page.to_f).ceil
    }
  end

  # GET /nutritionists/1
  def show
    render json: @nutritionist
  end

  # POST /nutritionists
  def create
    @nutritionist = Nutritionist.new(nutritionist_params)

    if @nutritionist.save
      render json: @nutritionist, status: :created, location: @nutritionist
    else
      render json: @nutritionist.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /nutritionists/1
  def update
    if @nutritionist.update(nutritionist_params)
      render json: @nutritionist
    else
      render json: @nutritionist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /nutritionists/1
  def destroy
    @nutritionist.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nutritionist
      @nutritionist = Nutritionist.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def nutritionist_params
      params.expect(nutritionist: [ :name, :address, :price ])
    end
end
