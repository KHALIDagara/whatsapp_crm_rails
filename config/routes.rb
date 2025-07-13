# config/routes.rb
Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get "messages/create"
  get "conversations/index"
  get "conversations/show"
  devise_for :users

  authenticated :user do
    root 'accounts#index', as: :authenticated_root
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  get 'dashboard', to: 'dashboard#index'

  # Add :new to this line to generate the new_account_path
  resources :conversations, only: [:index, :show] do 
    resources :messages, only: :create
  end


  resources :accounts, only: [:index, :new, :create, :destroy , :edit, :update]  do
    member do
      get :status
    end
  end
   # --- NEW WEBHOOK ROUTE ---
  # This creates a public-facing URL to receive POST requests from the Evolution API.
  # The :secret parameter makes the URL unique and secure for each account.
  # e.g., POST /webhooks/receive/a-very-long-and-random-secret
  post 'webhooks/receive/:secret', to: 'webhooks#receive', as: :webhooks_receive
end
