class Post < ApplicationRecord
  belongs_to :user
  attachment :image
  has_many :likes, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  def liked_by(user)
    Like.find_by(user_id: user.id, post_id: id)
# user_idとpost_idが一致するlikeを検索する
  end

  def save_tag(savepost_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - savepost_tags
    new_tags = savepost_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name: old_name)
    end

    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(tag_name: new_name)
      self.tags << post_tag
    end
  end
end
