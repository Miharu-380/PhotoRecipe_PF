class Public::HomesController < ApplicationController
  def top
  end

  def index
    @posts = Post.order(created_at: "DESC").includes(:user).page(params[:page]).per(25)
    @tag_list = Tag.all
  end

end
