class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, except: %i(index new create)

  def index
    @users = User.all.page(params[:page]).per Settings.per_page_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "mail.check_email"
      redirect_to root_url
    else
      flash[:danger] = t "user.alert_up_fail"
      render :new
    end
  end

  def show
    if @user
      @microposts = @user.microposts.page(params[:page]).per Settings.microitem
    else
      redirect_to root_url
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "user.updated.title_profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.delete.user-delete"
    else
      flash[:danger] = t "user.delete.user-no-delete"
    end
    redirect_to users_url
  end

  def following
    @title = t "following"
    @users = @user.following.page(params[:page]).per Settings.follow_in_per
    render :show_follow
  end

  def followers
    @title = t "followers"
    @users = @user.followers.page(params[:page]).per Settings.follow_in_per
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "user.login.please-login"
    redirect_to login_url
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless @user == current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "user.not_found"
    redirect_to root_path
  end
end
