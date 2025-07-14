Rails.application.routes.draw do
  # Mount the real-time server at the top.
  mount ActionCable.server => '/cable'

  # Set up all Devise routes for user authentication.
  devise_for :users

  # Define the root pages for logged-in and logged-out users.
  authenticated :user do
    root 'contacts#index', as: :authenticated_root # Default to contacts page
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # Define all the application's resources cleanly.
  resources :accounts, only: [:index, :new, :create, :edit, :update, :destroy] do
    member do
      get :status
    end
  end

  resources :conversations, only: [:index, :show] do
    resources :messages, only: :create
  end
  
  resources :contacts, only: [:index, :new, :create, :edit, :update, :destroy] do
    patch :bulk_update, on: :collection
  end

  resources :campaigns, only: [:new, :create, :show]

  # This is the public endpoint for receiving webhooks.
  post 'webhooks/receive/:secret', to: 'webhooks#receive', as: :webhooks_receive
end
