import { Controller } from "@hotwired/stimulus"

// Polls an endpoint to check the connection status of the QR code.
export default class extends Controller {
  static values = {
    url: String,        // The URL to poll for status updates
    redirectUrl: String // The URL to redirect to upon successful connection
  }
  static targets = ["statusText"]

  connect() {
    // --- ADD THIS LINE FOR DEBUGGING ---
    // This message should appear in your browser's developer console.
    console.log("✅ QR Status Controller connected and polling started!");

    // Start polling as soon as the controller is connected to the DOM.
    this.pollingInterval = setInterval(() => {
      this.checkStatus()
    }, 3000)
  }

  disconnect() {
    // Important: Stop polling when the user navigates away from the page
    clearInterval(this.pollingInterval)
  }

  async checkStatus() {
    const response = await fetch(this.urlValue)
    const data = await response.json()

    if (data.status === 'connected') {
      this.disconnect() // Stop polling
      this.statusTarget.textContent = "✅ Connected! Redirecting..."
      Turbo.visit(this.redirectUrlValue)
    }
  }
}
