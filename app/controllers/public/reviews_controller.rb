class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = Review.new(review_params)
    @post = @review.post
    if @review.save
      respond_to :js
    else
      flash[:alert] = "コメントに失敗しました"
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @post = @review.post
    if @review.destroy
      respond_to :js
    else
      flash[:alert] = "コメントの削除に失敗しました"
    end
  end

  private

  def review_params
    params.required(:review).permit(:user_id, :post_id, :review, :reply)
  end
end
