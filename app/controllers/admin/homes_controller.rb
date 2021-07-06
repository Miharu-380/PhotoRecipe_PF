class Admin::HomesController < ApplicationController
  def top
    @posts = Post.all
  end
end
