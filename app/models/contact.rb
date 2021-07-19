class Contact < ApplicationRecord
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :name, presence: true
  validates :subject, presence: true
  validates :message, presence: true

  enum subject: { question: 1, wantto_delete: 2, everything: 3 }
end
