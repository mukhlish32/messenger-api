class MessagesController < ApplicationController
  before_action :set_conversation, only: [:index]
  before_action :set_message, only: [:show]

  # GET /conversations/:conversation_id/messages
  def index
    authorize_conversation_access
    @messages = @conversation.chat_messages.includes(:sender)
    serialized_messages = @messages.map { |message| MessageSerializer.new(message).as_json }
    json_response(serialized_messages)
  end

  # POST /messages
  def create
    conversation = Conversation.find(params[:conversation_id])

    # Create the chat message
    chat_message = conversation.chat_messages.new(
      sender_id: params[:user_id],
      message: params[:message],
    )

    if chat_message.save
      json_response(MessageSerializer.new(chat_message, true).as_json, :created)
    else
      json_response({ error: chat_message.errors.full_messages.join(", ") }, :unprocessable_entity)
    end
  end

  # GET /messages/:id
  def show
    authorize_conversation_access
    update_message_read_at
    json_response(MessageSerializer.new(@message).as_json)
  end

  private

  def set_conversation
    @conversation = Conversation.includes(:with_user, :chat_messages).find_by(id: params[:conversation_id])

    unless @conversation
      raise ActiveRecord::RecordNotFound, "Conversation not found"
    end
  end

  def authorize_conversation_access
    unless @conversation
      raise ActiveRecord::RecordNotFound, "Conversation not found"
    end

    unless @conversation.user_id == current_user.id || @conversation.with_user_id == current_user.id
      raise ExceptionHandler::Forbidden, "You are not authorized to access this conversation"
    end
  end

  def update_message_read_at
    return if @message.read_at.present?

    @message.update!(read_at: Time.zone.now)
  end

  def set_message
    @message = @conversation.chat_messages.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    json_response({ message: e.message }, :not_found)
  end
end
