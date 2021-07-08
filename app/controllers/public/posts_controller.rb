class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_post, only: [:edit, :show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    tag_list = params[:post][:tag_ids].split(' ')
    @post.user_id = current_user.id
    if @post.save
      @post.save_tag(tag_list)
      redirect_to root_path
      flash[:notice] = "投稿しました"
    else
      render 'new'
    end
  end

  def show
    @tags = @post.tags
  end

  def edit
    @tag_list =@post.tags.pluck(:tag_name).join(' ')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_ids].split(' ')
    @post.user_id = current_user.id
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(@post)
      flash[:投稿を更新しました]
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
    flash[:notice] = "投稿を削除しました"
  end

 private

  def post_params
    params.require(:post).permit(:image, :title, :photo_app, :photo_filter, :fix_app, :fix_filter, :exposure, :highlight, :burilliance, :shadow, :contrast, :brightness, :saturation, :warmth, :sharpness, :body)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
