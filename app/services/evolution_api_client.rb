# app/services/evolution_api_client.rb
require 'faraday'
require 'faraday/retry'

class EvolutionApiClient
  BASE_URL = 'http://localhost:8082'.freeze
  GLOBAL_API_KEY = 'mude-me'.freeze

  def initialize
    # Set up a connection template with default settings
    @connection = Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :retry, { max: 2, interval: 0.5 }
      faraday.adapter Faraday.default_adapter
    end
  end

# NEW: Sets the webhook configuration for a given instance.
  def set_webhook(account)
    return nil unless account.webhook_url.present?
    events_to_listen = [
      "CONNECTION_UPDATE",
      "MESSAGES_UPSERT",
      "QRCODE_UPDATED"
    ]

    @connection.post("webhook/set/#{account.instance_name}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['apikey'] = GLOBAL_API_KEY
      req.body = {
        webhook: {
        url: account.webhook_url,
        enabled: true,
        webhookByEvents: true,   
        events: events_to_listen
        
      }
      }.to_json
    end
  end

  # Creates a new instance in the Evolution API.
def create_instance(account)
    public_base_url = Rails.application.credentials.app[:public_base_url]
    webhook_full_url = public_base_url + Rails.application.routes.url_helpers.webhooks_receive_path(secret: account.webhook_secret)

    response = @connection.post('instance/create') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['apikey'] = GLOBAL_API_KEY
      req.body = {
        instanceName: account.instance_name,
        token: account.api_key,
        qrcode: true,
        # UPDATED: Use the phone number from the account object
        number: account.phone_number,
        integration: "WHATSAPP-BAILEYS",
        webhookUrl: webhook_full_url,
        webhookByEvents: true,
        webhookEvents: [
          "APPLICATION_STARTUP",
          "QRCODE_UPDATED",
          "CONNECTION_UPDATE",
          "MESSAGES_UPSERT"
        ],
        reject_call: true,
        groupsIgnore: true,
        alwaysOnline: true,
        readMessages: true,
        readStatus: true,
        syncFullHistory: true
      }.to_json
    end
    handle_response(response)
  end
  # Fetches the connection state for a given instance.
  def connection_state(account)
    response = @connection.get("instance/connectionState/#{account.instance_name}") do |req|
      req.headers['apikey'] = GLOBAL_API_KEY # Use global key
    end
    handle_response(response)
  end

  # Fetches profile info after connection.
  def fetch_profile_info(account)
    jid = "#{account.phone_number}@s.whatsapp.net"
    response = @connection.get("chat/fetchProfileInfo/#{jid}") do |req|
      req.headers['apikey'] = GLOBAL_API_KEY # Use global key
    end
    handle_response(response)
  end

    # NEW: Sends a text message via the Evolution API.
  def send_text(account, recipient_number, text)
    # The recipient number should not have the "@s.whatsapp.net" suffix here.
    clean_recipient_number = recipient_number.split('@').first

    @connection.post("message/sendText/#{account.instance_name}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['apikey'] = GLOBAL_API_KEY
      req.body = {
        number: clean_recipient_number,
        text: text
      }.to_json
    end
  end



  private

  def handle_response(response)
    unless response.success?
      Rails.logger.error "Evolution API Error: Status #{response.status}, Body: #{response.body}"
      return nil
    end
    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error "Evolution API JSON Parse Error: #{e.message}"
    nil
  rescue Faraday::Error => e
    Rails.logger.error "Faraday Connection Error: #{e.message}"
    nil
  end
end
