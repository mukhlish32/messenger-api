class ChatMessage < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  validates :content, presence: true

  scope :unread, -> { where(read_at: nil) }
end
