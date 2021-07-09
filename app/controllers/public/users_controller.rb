class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render 'edit'
    end
  end

  def unsubscribe
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
    flash[:notice] = "ご利用ありがとうございました。"
  end

  def bookmark
    @bookmarks = Bookmark.where(user_id: current_user.id)
  end
 private

  def user_params
    params.require(:user).permit(:name, :username, :profile_image, :introduction)
  end



end
