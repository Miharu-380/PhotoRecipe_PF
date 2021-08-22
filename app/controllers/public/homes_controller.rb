class Public::HomesController < ApplicationController
  def top
  end

  def index
    @posts = Post.post_index.page(params[:page]).per(30)
    @tag_list = Tag.all
  end
end
