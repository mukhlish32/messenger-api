class ConversationSerializer
  def initialize(conversation, include_details = true)
    @conversation = conversation
    @include_details = include_details
  end

  def as_json
    json = {
      id: @conversation.id,
      with_user: {
        id: @conversation.with_user.id,
        name: @conversation.with_user.name,
        photo_url: @conversation.with_user.photo_url,
      },
    }

    if @include_details
      json[:last_message] = last_message_info
      json[:unread_count] = unread_message_count
    end

    json
  end

  private

  def last_message_info
    last_message = @conversation.chat_messages.last
    return nil unless last_message

    {
      id: last_message.id,
      sender: {
        id: last_message.sender.id,
        name: last_message.sender.name,
      },
      sent_at: last_message.created_at.iso8601,
    }
  end

  def unread_message_count
    @conversation.chat_messages.unread.count
  end
end
