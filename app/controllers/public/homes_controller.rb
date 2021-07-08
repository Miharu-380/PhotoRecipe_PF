class Public::HomesController < ApplicationController

  def top
    @posts = Post.all
    @tag_list = Tag.all
  end

  def about
  end

end
