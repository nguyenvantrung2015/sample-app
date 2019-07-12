class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params

    if @micropost.save
      flash[:success] = t "micropost.created_success"
    else
      flash[:danger] = t "micropost.created_fail"
    end
    redirect_to root_url
  end

  def destroy
    flash[:success] = if @micropost.destroy
                        t "micropost.deleted"
                      else
                        t "micropost.deleted_not"
                      end
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end
end
