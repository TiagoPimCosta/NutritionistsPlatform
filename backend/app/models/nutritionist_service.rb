class NutritionistService < ApplicationRecord
  belongs_to :nutritionist
  belongs_to :service
  has_many :appointments, dependent: :destroy

  validates :street, :city, presence: true
  validates :price_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
  validates :nutritionist_id, uniqueness: { scope: [ :service_id, :city ] }

  def duration
    duration_minutes.minutes
  end
end
