class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_hashtags
  has_many :hashtags, through: :post_hashtags
  mount_uploader :image, ImageUploader

  validates :image, presence: true

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  def self.last_week
    Post.joins(:likes).where(likes: { created_at: 0.days.ago.prev_week..0.days.ago.prev_week(:sunday)}).group(:id).order("count(*) desc")
  end

  # 退会済の投稿は非表示
  def self.post_index
    Post.includes(:user).where(users: { is_deleted: false }).order(created_at: :desc)
  end

  def bookmarked_by(user)
    Bookmark.find_by(user_id: user.id, post_id: id)
  end

  after_create do
    post = Post.find_by(id: self.id)
    hashtags = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    post.hashtags = []
    hashtags.uniq.map do |hashtag|
      # ハッシュタグは先頭の'#'を外した上で保存
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end

  before_update do
    post = Post.find_by(id: self.id)
    post.hashtags.clear
    hashtags = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end
end
