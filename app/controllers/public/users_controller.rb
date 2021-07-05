class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.save
      redirect_to user_path(@user.id)
    end
  end

  def unsubscribe
  end

  def withdraw
  end

 private

  def user_params
    params.require(:user).permit(:name, :username, :profile_image, :introduction)
  end



end
