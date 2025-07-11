# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  layout :layout_by_resource

  private

  # This method chooses the layout based on the controller being used.
  # If it's a Devise controller (for login, signup), it uses the "unauthenticated" layout.
  # Otherwise, it uses the main "application" layout.
  def layout_by_resource
    if devise_controller? 
      "unauthenticated"
    else
      "application"
    end
  end
end
