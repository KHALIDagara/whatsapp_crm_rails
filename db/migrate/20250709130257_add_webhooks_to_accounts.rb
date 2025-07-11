class AddWebhooksToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :webhook_url, :string
    add_column :accounts, :webhook_secret, :string
    add_index :accounts, :webhook_secret, unique: true
  end
end
