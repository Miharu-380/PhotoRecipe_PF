class Public::HomesController < ApplicationController
  def top
  end

  def index
    @posts = Post.all.order(created_at: :desc)
    @tag_list = Tag.all
  end
end
