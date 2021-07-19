class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :show, :update, :unsubscribe, :destroy]
  before_action :ensure_correct_user, only: [:edit]

  def show
    @posts = @user.posts
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render 'edit'
    end
  end

  def unsubscribe
  end

  def destroy
    @user.update(is_deleted: true)
    reset_session
    redirect_to index_path
    flash[:notice] = "ご利用ありがとうございました。"
  end

  def bookmark
    @bookmarks = Bookmark.where(user_id: current_user.id)
  end

  def timeline
    @feeds = Post.where(user_id: [current_user.id, *current_user.following_ids])
    # *で配列を展開して、current_user.idと合体
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :profile_image, :introduction)
  end

  # def set_user
  #   @user = User.find(params[:id])
  # end

  def ensure_correct_user
    unless @user == current_user
      redirect_to index_path
    end
  end
end
