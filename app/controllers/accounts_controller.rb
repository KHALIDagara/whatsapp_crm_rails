# app/controllers/accounts_controller.rb
class AccountsController < ApplicationController
  before_action :set_account, only: [:status, :destroy]

  def index
    @accounts = current_user.accounts.order(created_at: :desc)
  end

  # NEW: This action prepares a new account object for the form
  def new
    @account = Account.new
  end

  # MODIFIED: This action now receives data from the form
  def create
    # Sanitize the user-provided name to create a safe instance name
    safe_name = params[:account][:name].parameterize
    instance_name = "user_#{current_user.id}_#{safe_name}_#{Time.now.to_i}"
    api_key = SecureRandom.hex(32)

    # Build the account with data from the form and our generated values
    @account = current_user.accounts.build(account_params)
    @account.assign_attributes(
      instance_name: instance_name,
      api_key: api_key,
      status: :pending
    )

    if @account.save
      api_client = EvolutionApiClient.new
      response_data = api_client.create_instance(@account)

      qr_code_string = response_data&.dig('qrcode', 'code')

      if qr_code_string.present?
        # --- THIS IS THE FIX ---
        # 1. Create a QR code object from the string returned by the API.
        qrcode = RQRCode::QRCode.new(qr_code_string)

        # 2. Generate a PNG image and convert it to a Base64 data URL.
        # This creates the full "data:image/png;base64,..." string needed by the <img> tag.
        @qr_code_image_data_url = qrcode.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 280, # Increased size for better readability
          border_modules: 4,
          module_px_size: 6
        ).to_data_url

        render :show_qr, status: :created
      else
        @account.destroy
        # Redirect back to the form with an error
        redirect_to new_account_path, alert: 'Failed To Retrieve the Qr code .. Try again ! '
      end
    else
      # If validations fail (e.g., name is blank), re-render the form
      render :new, status: :unprocessable_entity
    end
  end

  def status
    api_client = EvolutionApiClient.new
    state_data = api_client.connection_state(@account)

    Rails.logger.info "---- EVOLUTION API STATUS RESPONSE: #{state_data.inspect} ----"

    # --- THE FIX IS HERE ---
    # We use .dig() to safely navigate the nested JSON: instance -> state
    if state_data && state_data.dig('instance', 'state') == 'open'

      # Once connected, we also need to dig deeper for the user info.
      user_data = state_data.dig('instance', 'user')
      if user_data
        phone = user_data['id'].split(':').first
        name = user_data['name']
        @account.update(status: :connected, phone_number: phone, name: name)
      else
        # Fallback if user data isn't present yet, just update the status.
        @account.update(status: :connected)
      end

      render json: { status: 'connected', redirect_url: accounts_path }
    else
      # Respond that the user is still waiting to scan
      render json: { status: 'pending' }
    end
  end

 # prepare the account object for edit form
  def edit 
      @account = current_user.accounts.find(params[:id])
  end

  # NEW : handles the subbmission of the webhook form 
  def update
    @account = current_user.accounts.find(params[:id])
    if @account.update(account_params)
      # After saving to our DB, update the webhook on the Evolution API.
      api_client = EvolutionApiClient.new
      api_client.set_webhook(@account)
      redirect_to accounts_path, notice: "Webhook URL updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end



  # NEW: Strong parameters to securely accept form data
  # MODIFIED: Update the strong params to allow :webhook_url.
  def account_params
    params.require(:account).permit(:name, :phone_number, :webhook_url)
  end


  def destroy
    # Future: Call API to delete instance
    @account.destroy
    redirect_to accounts_path, notice: 'Account was successfully unlinked.'
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

end
