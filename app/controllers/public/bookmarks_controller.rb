class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @bookmark = current_user.bookmarks.build(bookmark_params) # 親モデル.子モデル.buildという形式
    @post = @bookmark.post
    if @bookmark.save
      respond_to :js
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @post = @bookmark.post
    if @bookmark.destroy
      respond_to :js
    end
  end

  private

  def bookmark_params
    params.permit(:post_id)
  end
end
