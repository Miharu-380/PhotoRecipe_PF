class Review < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :review, presence: true
end
