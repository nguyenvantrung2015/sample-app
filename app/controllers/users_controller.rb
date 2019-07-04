class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "user.alert_up"
      redirect_to @user
    else
      flash[:success] = t "user.alert_up_fail"
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user
    redirect_to signup_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
