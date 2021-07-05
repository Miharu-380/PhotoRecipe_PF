class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # class_name　ここから探す
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # through　中間テーブルを介してUserテーブルから探すイメージ
  # フォローしてくれたユーザーを中間テーブルをスルーしてUserテーブルから探す→follower_id（自分をフォローするユーザーID）参照
  has_many :followings, through: :relationships, source: :followed
  # フォローしているユーザーを中間テーブルをスルーしてUserテーブルから探す→followed_id（自分にフォローされるユーザーID）参照

   USERNAME_REGEXP = /\A[a-zA-Z0-9][\w-]+\z/
  # 半角英数字記号_-のみ
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # 有効なメールアドレス
  validates :name, presence: true, length: {maximum: 50 }
  validates :username, format: { with: USERNAME_REGEXP }, presence: true, uniqueness: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, presence: true, uniqueness: true

  attachment :profile_image

  def active_for_authentication?
    super && (is_deleted == false)
  end

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
end
