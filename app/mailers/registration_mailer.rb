class RegistrationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.registration_mailer.sign_up.subject
  #
  def sign_up(user)
    @user = user 

    mail to: @user.email, subject: "Welcome to Facebook Neue!"
  end
end
