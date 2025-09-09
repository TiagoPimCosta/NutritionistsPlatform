class Appointment < ApplicationRecord
  belongs_to :nutritionist
  belongs_to :guest
  belongs_to :appointment_status
end
