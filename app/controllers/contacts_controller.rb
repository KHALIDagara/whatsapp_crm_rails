class ContactsController < ApplicationController
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

  def edit
  end

  def update
    if @contact.update(contact_params)
      render partial: 'contact', locals: { contact: @contact }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # --- CORRECTED ACTION ---
  def bulk_update
    contacts_hash = params.fetch(:contacts, {})

    Contact.transaction do
      contacts_hash.each do |id, attributes|
        contact = current_user.contacts.find(id)
        # Permit the attributes for each contact securely inside the loop.
        permitted_attributes = attributes.permit(:name, :whatsapp_number, :country, :status, :notes, :tag_list)
        contact.update!(permitted_attributes)
      end
    end

    redirect_to contacts_path, notice: "Contacts updated successfully."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to contacts_path, alert: "Failed to update contacts: #{e.message}"
  end
  
  private

  def set_contact
    @contact = current_user.contacts.find(params[:id])
  end

  # This is for the single-edit update action, which we are not using right now.
  def contact_params
    params.require(:contact).permit(:name, :whatsapp_number, :country, :status, :notes, :tag_list)
  end

  # The bulk_update_params method is no longer needed.
end
