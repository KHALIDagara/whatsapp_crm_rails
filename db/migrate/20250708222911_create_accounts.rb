class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :phone_number
      t.string :status, default: 'pending', null: false
      t.string :instance_name, null: false
      t.string :api_key, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :accounts, :instance_name, unique: true
    add_index :accounts, :api_key, unique: true
  end
end

