class Guest < ApplicationRecord
  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  normalizes :email, with: ->(email) { email.strip.downcase }
end
