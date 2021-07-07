class Post < ApplicationRecord
  belongs_to :user
  attachment :image
  has_many :likes, -> { order(created_at: :desc) }, dependent: :destroy
  
  def liked_by(user)
    Like.find_by(user_id: user.id, post_id: id)
# user_idとpost_idが一致するlikeを検索する
  end
end
