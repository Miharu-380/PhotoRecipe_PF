class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 半角英数字のみ
  VALID_PASSWORD_REGEX = /\A[a-z0-9]+\z/i
  # 有効なメールアドレス
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # 半角英数字記号_-のみ
  USERNAME_REGEXP = /\A[a-zA-Z0-9][\w-]+\z/
  validates :password, format: { with: VALID_PASSWORD_REGEX }, presence: true
  validates :name, presence: true, length: {maximum: 50 }
  validates :username, format: { with: USERNAME_REGEXP }, presence: true, uniqueness: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, presence: true, uniqueness: true
end
