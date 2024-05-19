class RenameMessagesToChatMessages < ActiveRecord::Migration[6.0]
  def change
    rename_table :messages, :chat_messages
  end
end
