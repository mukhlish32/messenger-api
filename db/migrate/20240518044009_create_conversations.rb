class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :with_user, null: false
      t.timestamps
    end

    add_foreign_key :conversations, :users, column: :with_user_id
    add_index :conversations, [:user_id, :with_user_id], unique: true
  end
end
