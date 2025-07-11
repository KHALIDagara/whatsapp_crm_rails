class MessagesController < ApplicationController
  def create
    @conversation = Conversation.joins(:account)
                                  .where(accounts: { user_id: current_user.id })
                                  .find(params[:conversation_id])

    # Enqueue the background job to send the message
    MessageSendingJob.perform_later(
      @conversation.id,
      message_params[:body]
    )
    
    # Create the message locally immediately for a faster UI update upon reload.
    # This prevents waiting for the background job to finish.
    @conversation.messages.create!(
      body: message_params[:body],
      from_me: true,
      sent_at: Time.current,
      message_uid: "local_#{SecureRandom.uuid}"
    )

    # Redirect back to the conversation, which will reload the page
    # and show the newly created message.
    redirect_to conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
