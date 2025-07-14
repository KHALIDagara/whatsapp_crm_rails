import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bulk-selection"
export default class extends Controller {
  static targets = ["selectAll", "checkbox"]

  connect() {
    console.log("✅ Bulk selection controller connected.");
  }

  // This function is triggered when the "select all" checkbox is clicked.
  toggleAll() {
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = this.selectAllTarget.checked
    })
  }

  // This function is triggered when the "Send Bulk WhatsApp" button is clicked.
  submitSelection(event) {
    event.preventDefault() // Stop the link from navigating to "#"
    
    const selectedIds = this.checkboxTargets
                              .filter(c => c.checked)
                              .map(c => c.value)

    // If no contacts are selected, show an alert and stop.
    if (selectedIds.length === 0) {
      alert("Please select at least one contact.")
      return
    }

    // Construct the URL and navigate to the new campaign page.
    const url = `/campaigns/new?contact_ids=${selectedIds.join(',')}`
    window.location.href = url
  }
}
