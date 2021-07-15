class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render 'edit'
    end
  end

  def unsubscribe
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    redirect_to index_path
    flash[:notice] = "ご利用ありがとうございました。"
  end

  def bookmark
    @bookmarks = Bookmark.where(user_id: current_user.id)
  end

  def timeline
    @feeds = Post.where(user_id: [current_user.id, *current_user.following_ids] )
    # *で配列を展開して、current_user.idと合体
  end

 private

  def user_params
    params.require(:user).permit(:name, :username, :profile_image, :introduction)
  end



end
