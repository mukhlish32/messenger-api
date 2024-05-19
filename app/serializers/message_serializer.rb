class MessageSerializer
  def initialize(message, include_details = false)
    @message = message
    @include_details = include_details
  end

  def as_json
    json = {
      id: @message.id,
      message: @message.message,
      sender: {
        id: @message.sender.id,
        name: @message.sender.name,
      },
      sent_at: @message.created_at.iso8601,
    }

    json[:conversation] = conversation if @include_details
    json
  end

  private

  def conversation
    {
      id: @message.conversation.id,
      with_user: {
        id: @message.conversation.with_user.id,
        name: @message.conversation.with_user.name,
        photo_url: @message.conversation.with_user.photo_url,
      },
    }
  end
end
