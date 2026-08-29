class Appointment < ApplicationRecord
  belongs_to :guest
  belongs_to :nutritionist_service

  has_one :nutritionist, through: :nutritionist_service

  enum :status, { pending: 0, accepted: 1, rejected: 2, cancelled: 3 }, default: :pending

  validates :starts_at, presence: true
  validate  :starts_in_the_future, on: :create

  before_validation :set_ends_at

  scope :for_nutritionist, ->(nutritionist_id) {
    joins(:nutritionist_service).where(nutritionist_services: { nutritionist_id: nutritionist_id })
  }

  scope :overlapping, ->(starts_at, ends_at) {
    where("starts_at < ? AND ends_at > ?", ends_at, starts_at)
  }

  private

  def set_ends_at
    return if starts_at.blank? || nutritionist_service.blank?

    self.ends_at = starts_at + nutritionist_service.duration
  end

  def starts_in_the_future
    return if starts_at.blank?

    errors.add(:starts_at, "must be in the future") if starts_at <= Time.current
  end
end
