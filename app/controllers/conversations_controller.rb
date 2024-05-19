class ConversationsController < ApplicationController
  before_action :authorize_conversation_access, only: [:show]

  # GET /conversations
  def index
    conversations = current_user.conversations.includes(:with_user, :chat_messages)

    if conversations.empty?
      json_response([])
    else
      serialized_conversations = conversations.map { |conversation| ConversationSerializer.new(conversation).as_json }
      json_response(serialized_conversations)
    end
  end

  # POST /conversations
  def create
    with_user = User.find(params[:with_user_id])
    conversation = Conversation.create!(user: current_user, with_user: with_user)
    json_response(ConversationSerializer.new(conversation).as_json, :created)
  end

  # GET /conversations/:id
  def show
    json_response(ConversationSerializer.new(@conversation, false).as_json)
  end

  private

  def authorize_conversation_access
    @conversation = Conversation.find(params[:id])

    unless @conversation
      raise ActiveRecord::RecordNotFound, "Conversation not found"
    end

    unless @conversation.user_id == current_user.id || @conversation.with_user_id == current_user.id
      raise ExceptionHandler::Forbidden, "You are not authorized to access this conversation"
    end
  end
end
