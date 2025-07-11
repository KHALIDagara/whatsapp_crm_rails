class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.text :body
      t.boolean :from_me
      t.string :message_uid
      t.datetime :sent_at
      t.timestamps
    end
      add_index :messages, :message_uid, unique: true
  end
end
