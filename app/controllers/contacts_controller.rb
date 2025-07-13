class ContactsController < ApplicationController
  def index
    # let's fetch all contacts that belong to this user 
    @contacts  = current_user.contacts.order(created_at: :desc)
  end
end
