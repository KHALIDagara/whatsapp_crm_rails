class Contact < ApplicationRecord
  belongs_to :user
  # This line activates the tagging functionality from the gem.
  # We are defining one context for tagging called :tags.
  acts_as_taggable_on :tags

  enum :status,{ 
    customer: "customer",
    pending: "pending",
    phase_1: "phase_1",
    phase_2: "phase_2",
    phase_3: "phase_3"
  }
  #adding basic validation 
  validates :name, presence: true
  validates :whatsapp_number, presence: true

end
