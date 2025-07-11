class Account < ApplicationRecord
  belongs_to :user
  has_many :conversations, dependent: :destroy
  # Use an enum for status to make it more robust
  enum :status, { pending: 'pending', connected: 'connected', disconnected: 'disconnected' }

  # Add a callback to generate a webhook secret before the account is created.
  before_create :generate_webhook_secret

  private

  # This method generates a unique, URL-safe string to be used as a secret token.
  def generate_webhook_secret
    # self.webhook_secret will be set to a new random token, e.g., "7a2b9c..."
    # This loop ensures the token is unique, though collisions are extremely rare.
    self.webhook_secret = loop do
      random_token = SecureRandom.urlsafe_base64(32)
      break random_token unless Account.exists?(webhook_secret: random_token)
    end
  end
end
