class User < ApplicationRecord
  has_secure_password

  has_many :conversations, foreign_key: :user_id, dependent: :destroy
  has_many :chat_messages, foreign_key: :sender_id, dependent: :destroy

  has_many :received_conversations, class_name: "Conversation", foreign_key: :with_user_id, dependent: :destroy
  has_many :received_messages, through: :received_conversations, source: :chat_messages

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
