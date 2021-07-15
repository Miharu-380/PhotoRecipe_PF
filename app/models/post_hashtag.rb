class PostHashtag < ApplicationRecord
  belongs_to :post
  belongs_to :hashtag
  with_options presence: true do
    validates :post_id
    validates :hashtag_id
  end
end
