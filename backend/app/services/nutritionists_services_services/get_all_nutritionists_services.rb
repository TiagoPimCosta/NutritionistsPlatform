# frozen_string_literal: true

module NutritionistsServicesServices
  class GetAllNutritionistsServices
    def initialize(nutritionists_services_params)
      @nutritionists_services_params = nutritionists_services_params
    end

    def call
      nutritionists_services = NutritionistsService.includes(:nutritionist, :service).all

      if filter.present?
        nutritionists_services = nutritionists_services
          .joins(:nutritionist, :service)
          .where(
            "nutritionists.name ILIKE :filter OR services.name ILIKE :filter",
            filter: "%#{filter}%"
          ).distinct
      end

      total_count = nutritionists_services.count
      nutritionists_services = nutritionists_services.offset((page - 1) * per_page).limit(per_page)
      {
        success: true,
        records: {
          items: nutritionists_services.as_json(
            include: {
              nutritionist: { only: [ :id, :name ] },
              service: { only: [ :name ] }
            }
          ),
          page: page,
          per_page: per_page,
          total_count: total_count,
          total_pages: (total_count / per_page.to_f).ceil
        },
        errors: nil
      }
    rescue => e
      {
        success: false,
        records: nil,
        errors: [ { message: e.message } ]
      }
    end

    private

    attr_reader :nutritionists_services_params

    def filter
      nutritionists_services_params[:filter].to_s.strip
    end

    def page
      value = nutritionists_services_params[:page].to_i
      value > 0 ? value : 1
    end

    def per_page
      value = nutritionists_services_params[:per_page].to_i
      value > 0 ? value : 3
    end
  end
end
