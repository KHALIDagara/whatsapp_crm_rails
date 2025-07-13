class CreateCampaignMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_messages do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
    add_index :campaign_messages, :status
  end
end
