class Hashtag < ApplicationRecord
  validates :hashname, presence: true, length: { maximum:99}
  has_many :post_hashtags
  has_many :posts, through: :post_hashtags
end
