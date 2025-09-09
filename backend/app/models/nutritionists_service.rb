class NutritionistsService < ApplicationRecord
  belongs_to :nutritionist
  belongs_to :service
end
