class WebhookProcessingJob < ApplicationJob
  queue_as :default

  def perform(account_id, payload)
    account = Account.find_by(id: account_id)
    return unless account

    # Extract relevant data from the webhook payload
    data = payload.dig("data")
    message_data = data.dig("message")
    return unless message_data

    contact_identifier = data.dig("key", "remoteJid")
    contact_name = data.dig("pushName")
    message_body = message_data.dig("conversation")
    message_uid = data.dig("key", "id")
    from_me = data.dig("key", "fromMe")
    sent_at = Time.at(data.dig("messageTimestamp").to_i)

    # Ensure we have the essential data to proceed
    return unless contact_identifier && message_uid && message_body

    # Use a database transaction to ensure data integrity
    ApplicationRecord.transaction do
      # Find or create the conversation thread
      conversation = Conversation.find_or_create_by!(
        account: account,
        contact_identifier: contact_identifier
      )

      # Update the conversation with the latest info
      conversation.update!(
        contact_name: contact_name,
        last_message_at: sent_at
      )

      # Create the message, but only if it doesn't already exist (by its unique ID)
      unless Message.exists?(message_uid: message_uid)
        conversation.messages.create!(
          body: message_body,
          from_me: from_me,
          message_uid: message_uid,
          sent_at: sent_at
        )
      end
    end
  end
end
