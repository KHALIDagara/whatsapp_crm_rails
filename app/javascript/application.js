// Add a log at the very top to see if this file runs at all.
console.log("🚀 application.js has started executing...");

import "@hotwired/turbo-rails"
import "./controllers"

// This line is the most important for real-time features.
import "./channels" 

// Add a log at the end to confirm it finished.
console.log("✅ application.js has finished importing.");
