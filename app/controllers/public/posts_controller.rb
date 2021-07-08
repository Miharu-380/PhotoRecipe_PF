class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_post, only: [:edit, :show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to root_path
      flash[:notice] = "投稿しました"
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    @post = Post.find(params[:id])
    @post.user_id = current_user.id
    if @post.update(post_params)
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

  def hashtag
    @user = current_user
    @tag = Hashtag.find_by(hashname: params[:name])
    @posts = @tag.posts
  end

  def search
    redirect_to root_path if params[:keyword] == ""
    split_keyword = params[:keyword].split(/[[:blank:]]+/)
    @posts = []
    split_keyword.each do |keyword|
      next if keyword == "" # 空欄はスキップ→先頭に空欄がると全てヒットする
      @posts += Post.where('title LIKE(?) OR body LIKE(?) OR photo_app LIKE(?) OR photo_filter LIKE(?) OR fix_app LIKE(?) OR fix_filter LIKE(?)', "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")
    end
      @posts.uniq! #重複した商品を削除する
  end

 private

  def post_params
    params.require(:post).permit(:image, :title, :photo_app, :photo_filter, :fix_app, :fix_filter, :exposure, :highlight, :burilliance, :shadow, :contrast, :brightness, :saturation, :warmth, :sharpness, :body)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
