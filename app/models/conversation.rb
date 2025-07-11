class Conversation < ApplicationRecord
  belongs_to :account
  has_many :messages, dependent: :destroy

  # This sets up the model to broadcast changes to a unique channel
  # e.g., "conversation_123"
end
