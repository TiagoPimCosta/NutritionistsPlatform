class NotificationMailer < ApplicationMailer
  default from: "notifications@example.com"

  def accept_appointment_email
    @guest = params[:guest]
    @nutritionist = params[:nutritionist]
    @date = params[:date]
    @time = params[:time]

    @url  = "http://example.com/login"
    mail(to: @user.email, subject: "Appointment Accepted")
  end

  def reject_appointment_email
    @user = params[:user]
    @url  = "http://example.com/login"
    mail(to: @user.email, subject: "Appointment Rejected")
  end
end
