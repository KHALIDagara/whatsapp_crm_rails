# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  # This is a Devise helper that ensures a user is logged in before they
  # can access any action in this controller. If they aren't, they are
  # redirected to the sign-in page.
  before_action :authenticate_user!

  def index
    # The view will be rendered inside the main application layout.
  end
end
