class MessagesController < ApplicationController
  def create
    @conversation = Conversation.joins(:account)
                                  .where(accounts: { user_id: current_user.id })
                                  .find(params[:conversation_id])

    @message = @conversation.messages.new(
      body: message_params[:body],
      from_me: true,
      sent_at: Time.current 
    )
    @message.attachment.attach(message_params[:attachment])

    #let's determine if the message type based on the attachement type 
    if @message.attachment.attached?
      if @message.attachment.image?
        @message.message_type = :image
        elsif  @message.attachment.audio?
        @message.message_type  = :audio
      end
    else
      @message.message_type = :text
    end

    if @message.save
       MessageSendingJob.perform_later(@message.id)
    end

    redirect_to conversation_path(@conversation)
  end

  private


  def message_params
    params.require(:message).permit(:body, :attachment)
  end
end

