class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :with_user, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :user_id, uniqueness: { scope: :with_user_id }

  def last_message
    messages.order(created_at: :desc).first
  end

  def unread_count(user)
    messages.unread.where.not(sender_id: user.id).count
  end
end
