class SessionsController < ApplicationController
  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      check_activated user
    else
      flash.now[:danger] = t "mail.invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def get_session_mail
    params[:session][:email].downcase
  end

  def check_activated user
    if user.activated?
      log_in user
      check_remember user
      if params[:session][:remember_me] == Settings.remember_me_true
        remember user
      else
        forget user
      end
      redirect_back_or user
    else
      flash[:warning] = t "mail.check_email"
      redirect_to root_url
    end
  end

  def check_remember user
    if params[:session][:remember_me] == Settings.remember_me_true
      remember user
    else
      forget user
    end
  end
end
