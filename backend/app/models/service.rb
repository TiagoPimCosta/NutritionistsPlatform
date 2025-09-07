class Service < ApplicationRecord
  has_many :nutritionists_services
  has_many :nutritionists, through: :nutritionists_services
end