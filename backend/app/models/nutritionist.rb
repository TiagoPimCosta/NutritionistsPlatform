class Nutritionist < ApplicationRecord
  has_many :nutritionists_services
  has_many :services, through: :nutritionists_services
end