# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.16
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@rails/actioncable", to: "@rails--actioncable.js" # @8.0.200

# Pin controllers with proper JS extensions
pin "controllers/application"
pin "controllers/index"
pin "controllers/hello_controller"
pin "controllers/form_loading_controller"
pin "controllers/toggle_controller"
pin "controllers/test_controller"
pin "controllers/qr_status_controller"

# Pin channels - these need to be pinned individually for ActionCable to work
pin "channels/index"
pin "channels/consumer"
pin "channels/conversation_channel"
