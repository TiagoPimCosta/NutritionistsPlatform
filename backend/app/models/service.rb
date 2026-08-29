class Service < ApplicationRecord
  has_many :nutritionist_services, dependent: :destroy
  has_many :nutritionists, through: :nutritionist_services

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
