class Public::HomesController < ApplicationController
  def top
  end

  def index
  # 退会済の投稿は非表示
    @posts = Post.includes(:user).where(users: { is_deleted: false }).order(created_at: :desc).page(params[:page]).per(12)
    @tag_list = Tag.all
  end
end
