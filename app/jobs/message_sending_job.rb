class MessageSendingJob < ApplicationJob
  queue_as :default

  def perform(conversation_id, message_body)
    conversation = Conversation.find(conversation_id)
    account = conversation.account

    # Call the Evolution API to send the message for real.
    api_client = EvolutionApiClient.new
    response = api_client.send_text(
      account,
      conversation.contact_identifier,
      message_body
    )
    
    # Optional: Handle sending failure
    unless response&.success?
      Rails.logger.error "Failed to send message via Evolution API for conversation #{conversation.id}"
    end
  end
end
