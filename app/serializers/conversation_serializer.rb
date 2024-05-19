class ConversationSerializer
  def initialize(conversation)
    @conversation = conversation
  end

  def as_json
    {
      id: @conversation.id,
      with_user: {
        id: @conversation.with_user.id,
        name: @conversation.with_user.name,
        photo_url: @conversation.with_user.photo_url,
      },
      last_message: last_message_info,
      unread_count: unread_message_count,
    }
  end

  private

  def last_message_info
  attribute :last_message, if: Proc.new { |conversation| conversation.last_message.present? } do |conversation|
    last_message = @conversation.chat_messages.last
    return nil unless last_message

    {
      id: last_message.id,
      sender: {
        id: last_message.sender.id,
        name: last_message.sender.name,
        photo_url: last_message.sender.photo_url,
      },
      sent_at: last_message.created_at.iso8601,
    }
  end

  def unread_message_count
    @conversation.chat_messages.unread.count
  end
end
