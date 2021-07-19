class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:edit, :show, :update]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id)
    else
      render 'edit'
    end
  end

  def search
    @users = User.search(params[:user_keyword])
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :profile_image, :introduction)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
