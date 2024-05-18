class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show]

  # GET /conversations
  def index
    @conversations = current_user.conversations.all
    json_response(@conversations)
  end

  # POST /conversations
  def create
    with_user = User.find(params[:with_user_id])
    @conversation = Conversation.create!(user: current_user, with_user: with_user)
    json_response(@conversation, :created)
  end

  # GET /conversations/:id
  def show
    authorize_conversation_access
    json_response(@conversation)
  end

  private

  def authorize_conversation_access
    unless @conversation.user_id == current_user.id || @conversation.with_user_id == current_user.id
      raise ExceptionHandler::AuthenticationError, "Not authorized to access this conversation"
    end
  end

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end
