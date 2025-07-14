# CORRECTED: Class name is plural
class CampaignsController < ApplicationController
  def new
    @campaign = Campaign.new
    
    # CORRECTED: The parameter from the Stimulus controller is 'contact_ids'
    @contact_ids = params[:contact_ids]&.split(',') || []
    
    @contacts = current_user.contacts.where(id: @contact_ids)
    
    # CORRECTED: The view expects a plural variable '@accounts'
    @accounts = current_user.accounts.connected
  end

  def create
    # CORRECTED: The association is plural `current_user.campaigns`
    @campaign = current_user.campaigns.new(campaign_params)

    if @campaign.save
      # The hidden field name is 'contact_ids', not 'contacts_ids'
      contact_ids = params[:campaign][:contact_ids].split(',')
      contact_ids.each do |contact_id|
        @campaign.campaign_messages.create(contact_id: contact_id, status: :pending)
      end
      
      # CORRECTED: Typo `redirect_to`
      redirect_to @campaign, notice: "Campaign created successfully and is ready to send."
    else
      # If saving fails, we need to re-fetch the data for the form
      @contact_ids = params[:campaign][:contact_ids]&.split(',') || []
      @contacts = current_user.contacts.where(id: @contact_ids)
      @accounts = current_user.accounts.connected
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # CORRECTED: The association is plural `current_user.campaigns`
    @campaign = current_user.campaigns.find(params[:id])
  end

  private

  # CORRECTED: Typo `campaign_params`
  def campaign_params
    params.require(:campaign).permit(:message_body, :account_id, :attachment)
  end
end
