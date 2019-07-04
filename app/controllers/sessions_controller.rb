class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: get_session_mail

    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = t "login.error"
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
end