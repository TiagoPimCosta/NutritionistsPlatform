class NotificationMailer < ApplicationMailer
  default from: "notifications@example.com"

  def accept_appointment_email
    setup_appointment

    mail(to: @guest.email, subject: "Your appointment with #{@nutritionist.name} is confirmed")
  end

  def reject_appointment_email
    setup_appointment

    mail(to: @guest.email, subject: "Your appointment request with #{@nutritionist.name} has been rejected")
  end

  private

  def setup_appointment
    @appointment = params[:appointment]
    @guest = @appointment.guest
    @nutritionist = @appointment.nutritionist
    @service = @appointment.nutritionist_service
    @date = @appointment.starts_at.strftime("%d %B %Y")
    @time = @appointment.starts_at.strftime("%H:%M")
    @ends_at = @appointment.ends_at.strftime("%H:%M")
  end
end
