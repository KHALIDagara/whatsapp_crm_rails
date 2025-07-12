class MessageSendingJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    conversation = message.conversation
    account = conversation.account
    api_client = EvolutionApiClient.new

    case message.message_type.to_sym
    when :text
      api_client.send_text(account, conversation.contact_identifier, message.body)
    
    when :image
      # Get the raw base64 content, just like in your script
      base64_content = Base64.strict_encode64(message.attachment.download)

      # Call the updated method with the correct arguments
      api_client.send_image(account, conversation.contact_identifier, message.body, base64_content)
      
    when :audio
      # Get the raw base64 content, just like in your script
      base64_content = Base64.strict_encode64(message.attachment.download)

      # Call the updated method with the correct arguments
      api_client.send_audio(account, conversation.contact_identifier, base64_content)
    end
  end
end
