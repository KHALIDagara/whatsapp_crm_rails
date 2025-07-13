class Campaign < ApplicationRecord
  belongs_to :account
  belongs_to :user

  has_many :campaign_messages, dependent: :destroy
  has_many :contacts, through: :campaign_messages

  has_one_attached :attachement
end
