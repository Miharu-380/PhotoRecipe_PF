class Contact < ApplicationRecord
  validates :email, presence: true, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i} # メールアドレスの正規表現
  validates :message, presence: true

  enum subject:{selection: 0, question: 1, wantto_delete: 2, everything: 3}
end