class Message < ApplicationRecord
  belongs_to :conversation
  has_one_attached :attachment
  

  enum :message_type, {
    text: "text",
    image: "image",
    audio: "audio"
  }

  after_create_commit { broadcast_append_to conversation } 
end
