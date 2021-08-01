class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.follow(params[:user_id])
  # request.referer 遷移前ページ
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings.where(users: { is_deleted: false }).order(created_at: :desc)
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers.where(users: { is_deleted: false }).order(created_at: :desc)
  end
end
