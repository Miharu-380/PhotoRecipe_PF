class Public::HomesController < ApplicationController

  def top
  end

  def index
    @posts = Post.all
    @tag_list = Tag.all
  end

end
