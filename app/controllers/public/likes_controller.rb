class Public::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.new(user_id: current_user.id)
    if @like.save
      respond_to :js
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = @post.likes.find_by(user_id: current_user.id)
    if @like.destroy
      respond_to :js
    end
  end
end
