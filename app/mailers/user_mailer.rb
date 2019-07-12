class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mail.account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("format_password.reset_pwd")
  end
end
