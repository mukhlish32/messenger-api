class RenameContentToMessageInChatMessages < ActiveRecord::Migration[6.0]
  def change
    rename_column :chat_messages, :content, :message
  end
end
