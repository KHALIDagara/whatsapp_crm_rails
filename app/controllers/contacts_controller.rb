class ContactsController < ApplicationController
  # Add this before_action to find the contact for edit/update
  before_action :set_contact, only: [:edit, :update]

  def index
    @contacts = current_user.contacts
    if params[:by_status].present?
      @contacts = @contacts.where(status: params[:by_status])
    end

    if params[:by_country].present?
      @contacts = @contacts.where(country: params[:by_country])
    end

    if params[:by_tag].present?
      @contacts = @contacts.tagged_with(params[:by_tag])
    end

    @contacts = @contacts.order(created_at: :desc)
  end


  # This action now just renders the edit form partial.
  # Turbo will automatically place it in the correct frame.
  def edit
  end

  # This action will handle the form submission and respond with a Turbo Stream.
  def update
    if @contact.update(contact_params)
      # On success, re-render the contact partial with the updated info
      render partial: 'contact', locals: { contact: @contact }
    else
      # On failure, re-render the edit form with error messages
      render :edit, status: :unprocessable_entity
    end
  end



 # NEW: This action handles the submission of the entire grid.
  def bulk_update
    # The params[:contacts] will be a hash like:
    # { "1" => { "name" => "New Name" }, "2" => { "status" => "phase_1" } }
    contacts = bulk_update_params[:contacts]

    # Use a transaction to ensure all updates succeed or none do.
    Contact.transaction do
      contacts.each do |id, attributes|
        contact = current_user.contacts.find(id)
        contact.update!(attributes)
      end
    end

    redirect_to contacts_path, notice: "Contacts updated successfully."
  rescue ActiveRecord::RecordInvalid => e
    # If any update fails, the transaction is rolled back.
    redirect_to contacts_path, alert: "Failed to update contacts: #{e.message}"
  end

  
  private

  def set_contact
    @contact = current_user.contacts.find(params[:id])
  end

  # Add all the fields we want to be updatable
  def contact_params
    params.require(:contact).permit(:name, :whatsapp_number, :country, :status, :notes, :tag_list)
  end



  def bulk_update_params
    params.permit(contacts: [:name, :whatsapp_number, :country, :status, :notes, :tag_list])
  end

  def contact_params
    params.require(:contact).permit(:name, :whatsapp_number, :country, :status, :notes, :tag_list)
  end




end
