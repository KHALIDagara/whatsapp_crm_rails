class CampaignMessage < ApplicationRecord
  belongs_to :campaign
  belongs_to :contact


  enum :status, { 
    pending: "pending",
    sent: "sent",
    failed: "failed"
  }
end
