class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :account, null: false, foreign_key: true
      t.string :contact_name
      t.string :contact_identifier
      t.datetime :last_message_at

      t.timestamps

    end

    add_index :conversations, [:account_id, :contact_identifier], unique: true

  end
end
