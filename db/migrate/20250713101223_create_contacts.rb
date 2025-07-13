class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :whatsapp_number
      t.string :country
      t.string :status
      t.text :notes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :contacts, :status
  end
end
