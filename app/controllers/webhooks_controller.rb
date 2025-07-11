class WebhooksController < ApplicationController
  # Skip user authentication, as this is an API endpoint for an external service.
  skip_before_action :authenticate_user!, only: [:receive]
  # Skip CSRF protection for this API endpoint.
  skip_before_action :verify_authenticity_token, only: [:receive]

  def receive
    # Find the account using the unique, secret token from the URL.
    account = Account.find_by(webhook_secret: params[:secret])

    # If no account is found with this secret, it's an unauthorized request.
    unless account
      head :unauthorized
      return
    end


    # --- SUCCESSFUL RECEIPT ---
    # For now, we will log the entire incoming payload to the Rails console
    # to prove that we are receiving messages and other events.
    Rails.logger.info "✅ Webhook received for account: #{account.name} (ID: #{account.id})"
    Rails.logger.info "✅ Payload: #{params.to_unsafe_h.inspect}"

     # Only process 'messages.upsert' events for now
    if params[:event] == "messages.upsert"
      # Use a background job for processing to keep the webhook response fast
      # This is a best practice for production apps.
      WebhookProcessingJob.perform_later(account.id, params.to_unsafe_h)
    end
    # Respond with a 200 OK status to let the Evolution API know we received it.
    head :ok
  end
end
