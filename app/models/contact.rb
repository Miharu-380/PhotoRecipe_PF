class Contact < ApplicationRecord
  validates :email, presence: true, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i} # メールアドレスの正規表現
  validates :message, presence: true

  enum subject:{question: 0, wantto_delete: 1, everything: 2}
end