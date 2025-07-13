// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
console.log("🚀 application.js loading...");

// Import Turbo first
import "@hotwired/turbo-rails"
console.log("✅ Turbo loaded");

// Import Stimulus
import "controllers"
console.log("✅ Controllers loaded");

// Import ActionCable channels
import "channels"
console.log("✅ Channels loaded");

console.log("✅ Application.js fully loaded");
