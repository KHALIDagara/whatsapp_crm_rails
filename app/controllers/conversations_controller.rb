class ConversationsController < ApplicationController
  def index
    @conversations = Conversation.joins(:account)
                                   .where(accounts: { user_id: current_user.id })
                                   .order(last_message_at: :desc)
    # When loading the index, there is no selected conversation yet.
    @conversation = nil
  end

  def show
    # --- ADD THIS LINE ---
    # We still need the full list to render the left pane.
    @conversations = Conversation.joins(:account)
                                   .where(accounts: { user_id: current_user.id })
                                   .order(last_message_at: :desc)

    # This finds the currently selected conversation for the right pane.
    @conversation = @conversations.find(params[:id])

    # Fetch messages for the selected conversation
    @messages = @conversation.messages.order(sent_at: :asc)
  end
end
